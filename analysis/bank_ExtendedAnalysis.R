###############################################################################
### Script: bank_ExtendedAnalysis.R
### Copyright (c) 2024 by Alan Montgomery. Distributed using license CC BY-NC 4.0
### To view this license see https://creativecommons.org/licenses/by-nc/4.0/
###
### This is suggested analysis for cross-selling telemarketing efforts for a
### portuguese bank
### This script does the following:
###  0) sets up the environment
###  1) imports the dataset from a text file
###  2) transform the data
###  3) understand the data computes descriptive statistics and plots
###  4) estimates a logistic regression model
###  5) computes predictions, a confusion matrix, the lift for the top decile
###
###############################################################################



###############################################################################
### setup
###############################################################################

# setup environment, make sure this library has been installed
if (!require(tree)) {install.packages("tree"); library(tree)}
# setup environment (if you want to use fancy tree plots)
if (!require(rpart)) {install.packages("rpart"); library(rpart)}
if (!require(rattle)) {install.packages("rattle"); library(rattle)}
if (!require(rpart.plot)) {install.packages("rpart.plot"); library(rpart.plot)}
if (!require(RColorBrewer)) {install.packages("RColorBrewer"); library(RColorBrewer)}
if (!require(party)) {install.packages("party"); library(party)}
if (!require(partykit)) {install.packages("partykit"); library(partykit)}
# a better scatterplot matrix routine
if (!require(car)) {install.packages("car"); library(car)}
# better summary tables
if (!require(psych)) {install.packages("psych"); library(psych)}
# data manipulation
if (!require(plyr)) {install.packages("plyr"); library(plyr)}

# import dataset from file (change the directory to where your data is stored)
setwd("~/Documents/class/analytical marketing/cases/portuguese bank")

# read in the data (notice that the columns are separated with semicolons not commas)
bank=read.csv("~/CMU/Analytical Marketing/Final - Portuguese Bank/bank-full.csv",header=TRUE,sep=";",stringsAsFactors=TRUE)



###############################################################################
### summarize the data
###############################################################################

# general description of the data
summary(bank)

# compute the number of observations
nobs=nrow(bank)

# set the random number seed so the samples will be the same if regenerated
set.seed(1248765792)

# prepare new values using a uniform random number, each record in freemium has 
# a corresponding uniform random value which will be used to decide if the observation
# is assigned to the training, validation or prediction sample
randvalue=runif(nobs)
trainsample=randvalue<.6    # 60% 
validsample=(randvalue>=.6 & randvalue<.9)
predsample=(randvalue>=.9)
plotsample=sample(1:nobs,300)

# create a list with the variables that will be used in the analysis
varlist=ls(bank)

# just a list of numeric variables
isnvar=sapply(bank,is.numeric)
nvarlist=attr(isnvar[isnvar],"names")



###############################################################################
### understanding the data with descriptive statistics and graphics
###############################################################################

# number of observations
sum(trainsample)
sum(validsample)
sum(predsample)

# let's take a look at just one observation
print(bank[1,])

# describe the data using only the training data
summary(bank[trainsample,varlist])

# use the describe function in the psych package to generate nicer tables
describe(bank[trainsample,varlist],fast=TRUE)

# do the same thing with the recoded data (but just for the training data)
describeBy(bank[trainsample,varlist],group=bank$y[trainsample],fast=TRUE)

# boxplots
par(mfrow=c(2,4))
boxplot(age~y,data=bank[plotsample,],xlab="adopter",ylab="age")
boxplot(balance~y,data=bank[plotsample,],xlab="adopter",ylab="balance")
boxplot(day~y,data=bank[plotsample,],xlab="adopter",ylab="day")
boxplot(duration~y,data=bank[plotsample,],xlab="adopter",ylab="duration")
boxplot(campaign~y,data=bank[plotsample,],xlab="adopter",ylab="campaign")
boxplot(pdays~y,data=bank[plotsample,],xlab="adopter",ylab="pdays")
boxplot(previous~y,data=bank[plotsample,],xlab="adopter",ylab="previous")

# boxplots, try it again with log scale--you can think about this as a percentage change
# and makes it easier to see differences between really large and small values
par(mfrow=c(2,4))
boxplot(age~y,data=bank[plotsample,],xlab="adopter",ylab="age",log="y")
boxplot(balance~y,data=bank[plotsample,],xlab="adopter",ylab="balance")  # balance can be negative
boxplot(day~y,data=bank[plotsample,],xlab="adopter",ylab="day",log="y")
boxplot(duration~y,data=bank[plotsample,],xlab="adopter",ylab="duration",log="y")
boxplot(campaign~y,data=bank[plotsample,],xlab="adopter",ylab="campaign",log="y")
boxplot(pdays~y,data=bank[plotsample,],xlab="adopter",ylab="pdays")  # zero days
boxplot(previous~y,data=bank[plotsample,],xlab="adopter",ylab="previous")  # zero days

# cross tabs
xtabs(~job+y,data=bank)
xtabs(~marital+y,data=bank)
xtabs(~education+y,data=bank)
xtabs(~default+y,data=bank)
xtabs(~housing+y,data=bank)
xtabs(~loan+y,data=bank)
xtabs(~contact+y,data=bank)
xtabs(~month+y,data=bank)
xtabs(~poutcome+y,data=bank)

# compute correlation matrix (using only complete sets of observations)
#print(cor(bank[,varlist],use="pairwise.complete.obs"),digits=1)

# pairs
par(mfrow=c(1,1),mar=c(5,4,4,1))
pairs(bank[plotsample,varlist])

# nicer scatterplot matrix
par(mfrow=c(1,1),mar=c(5,4,4,1))
scatterplotMatrix(~age+balance+duration|y,data=bank[plotsample,])
scatterplotMatrix(~age+balance+day+duration+campaign+pdays+previous|y,data=bank[plotsample,])



###############################################################################
### estimate a stepwise regression model with all the variables and their interactions
###############################################################################

# estimate simple logistic regression (with just trainsample)
lrmdl=glm(y~duration+housing,data=bank[trainsample,varlist],family='binomial')
summary(lrmdl)

# run a step-wise regression
# first estimate the null model (this just has an intercept)
null = glm(y~1,data=bank[trainsample,varlist],family='binomial')
summary(null)

# second estimate a complete model (with all variables that you are interested in)
full = glm(y~.,data=bank[trainsample,varlist],family='binomial')
summary(full)

# alternatively if you want to specify a specific logistic regression you can uncomment
# the following line and specify the variables that you want in the formula
#full = glm(y~.^2,data=bank[trainsample,varlist],family='binomial')

# finally estimate the step wise regression starting with the null model
# if you change to steps=20 or steps=30 you will get larger model
fwd = step(null, scope=formula(full),steps=15,dir="forward")
summary(fwd)

# select the model you are interested in evaluating (rerun for different models)
# but do not use this for the null model
mdl=fwd
mdl.lr=mdl

# predict probability (for validation sample) -- use these results when comparing models
padopter = predict(mdl,newdata=bank[validsample,varlist],type='response')
cadopter = (padopter>.25)+0
trueadopter = (as.vector(bank$y[validsample])=='yes')+0  # turn yes to 1 and no to 0
(results = xtabs(~cadopter+trueadopter) )  # confusion matrix (columns have truth, rows have predictions)
boxplot(padopter~bank$y[validsample])  # boxplot of probability for predictions
hist(padopter)  # histogram of probability of predicted adopters
(accuracy = (results[1,1]+results[2,2])/sum(results) )  # how many correct guesses along the diagonal
(truepos = results[2,2]/(results[1,2]+results[2,2]))  # how many correct "adopter" guesses
(precision = results[2,2]/(results[2,1]+results[2,2])) # proportion of correct positive guesses 
(trueneg = results[1,1]/(results[2,1]+results[1,1]))  # how many correct "non-adopter" guesses

# compute the predictions for the 10% of most likely adopterers (for validation sample)
topadopter = as.vector(padopter>=as.numeric(quantile(padopter,probs=.9)))
( baseconv=sum(trueadopter==1)/length(trueadopter) )  # what proportion would we have expected purely due to chance
( actconv=sum(trueadopter[topadopter])/sum(topadopter))  # what proportion did we actually predict
( lift=actconv/baseconv )  # what is the ratio of how many we got to what we expected

# predict probability (for prediction sample) -- use this sample to determine accuracy of your final model
padopter = predict(mdl,newdata=bank[predsample,varlist],type='response')
cadopter = as.vector((padopter>.25)+0)  # classify the predictions as adopters or not
trueadopter = (as.vector(bank$y[predsample])=='yes')+0  # turn yes to 1 and no to 0
(results = xtabs(~cadopter+trueadopter))  # confusion matrix
boxplot(padopter~bank$y[predsample])  # boxplot of probability for predictions
hist(padopter)  # histogram of probability of predicted adopters
(accuracy = (results[1,1]+results[2,2])/sum(results) )  # how many correct guesses along the diagonal
(truepos = results[2,2]/(results[1,2]+results[2,2]))  # how many correct "adopter" guesses
(precision = results[2,2]/(results[2,1]+results[2,2])) # proportion of correct positive guesses 
(trueneg = results[1,1]/(results[2,1]+results[1,1]))  # how many correct "non-adopter" guesses

# compute the predictions for the 10% of most likely adopterers (for prediction sample)
topadopter = as.vector(padopter>=as.numeric(quantile(padopter,probs=.9)))
( baseconv=sum(trueadopter==1)/length(trueadopter) )  # what proportion would we have expected purely due to chance
( actconv=sum(trueadopter[topadopter])/sum(topadopter))  # what proportion did we actually predict
( lift=actconv/baseconv )  # what is the ratio of how many we got to what we expected




###############################################################################
### estimate a tree model with all variables
###############################################################################

# use rpart to estimate a tree model
ctree = rpart(y~., data=bank[trainsample,varlist], control=rpart.control(cp=0.005))
summary(ctree)
plot(ctree)
text(ctree)
prp(ctree)
fancyRpartPlot(ctree)

# score the predictions from the model
mdl=ctree   # set mdl to one of the following models full, mytree, ctree
mdl.tree=mdl

# predict probability (for validation sample) -- use these results when comparing models
padopter = predict(mdl,newdata=bank[validsample,varlist],type='prob') 
padopter = padopter[,2]   # returns a matrix of predictions, we only want predictions of adopter
cadopter = (padopter>.25)+0
trueadopter = (as.vector(bank$y[validsample])=='yes')+0  # turn yes to 1 and no to 0
(results = xtabs(~cadopter+trueadopter) )  # confusion matrix (columns have truth, rows have predictions)
boxplot(padopter~bank$y[validsample])  # boxplot of probability for predictions
hist(padopter)  # histogram of probability of predicted adopters
(accuracy = (results[1,1]+results[2,2])/sum(results) )  # how many correct guesses along the diagonal
(truepos = results[2,2]/(results[1,2]+results[2,2]))  # how many correct "adopter" guesses
(precision = results[2,2]/(results[2,1]+results[2,2])) # proportion of correct positive guesses 
(trueneg = results[1,1]/(results[2,1]+results[1,1]))  # how many correct "non-adopter" guesses

# compute the predictions for the 10% of most likely adopterers (for validation sample)
topadopter = as.vector(padopter>=as.numeric(quantile(padopter,probs=.9)))
( baseconv=sum(trueadopter==1)/length(trueadopter) )  # what proportion would we have expected purely due to chance
( actconv=sum(trueadopter[topadopter])/sum(topadopter))  # what proportion did we actually predict
( lift=actconv/baseconv )  # what is the ratio of how many we got to what we expected

# predict probability (for prediction sample) -- use this sample to determine accuracy of your final model
padopter = predict(mdl,newdata=bank[predsample,varlist],type='prob')
padopter = padopter[,2]   # returns a matrix of predictions, we only want predictions of adopter
cadopter = as.vector((padopter>.25)+0)    # classify the predictions as adopters or not
trueadopter = (as.vector(bank$y[predsample])=='yes')+0  # turn yes to 1 and no to 0
(results = xtabs(~cadopter+trueadopter))  # confusion matrix
boxplot(padopter~bank$y[predsample])  # boxplot of probability for predictions
hist(padopter)  # histogram of probability of predicted adopters
(accuracy = (results[1,1]+results[2,2])/sum(results) )  # how many correct guesses along the diagonal
(truepos = results[2,2]/(results[1,2]+results[2,2]))  # how many correct "adopter" guesses
(precision = results[2,2]/(results[2,1]+results[2,2])) # proportion of correct positive guesses 
(trueneg = results[1,1]/(results[2,1]+results[1,1]))  # how many correct "non-adopter" guesses

# compute the predictions for the 10% of most likely adopterers (for prediction sample)
topadopter = as.vector(padopter>=as.numeric(quantile(padopter,probs=.9)))
( baseconv=sum(trueadopter==1)/length(trueadopter) )  # what proportion would we have expected purely due to chance
( actconv=sum(trueadopter[topadopter])/sum(topadopter))  # what proportion did we actually predict
( lift=actconv/baseconv )  # what is the ratio of how many we got to what we expected




###############################################################################
### export data for a simulator spreadsheet to "bank_lrmodeldata.csv"
### uses the models that were created above, so you must have trained your models
###
### the CSV file contains the:
###  a) the model parameters from our logistic regression,
###  b) average and standard deviation of the original data,
###  c) actual data values associated with selected users
###  d) predicted probabilities of the selected users
###############################################################################

# create list of customer indices to extract for our analysis
userlist=c(1,2,3,4)

# create vector of variables used in model called mvarlist, and add other variables that we want to write out
# these lines require the lrmdl and ctree to be created appropriately above
mvarlist=names(coefficients(lrmdl))[-1]   # get the variables used in your logistic regression moodel, except the intercept which is in first position
mvarlist=unlist(unique(strsplit(mvarlist,":")))   # if you have interactions then you need to uncomment this line
mvarlist.tree=names(ctree$variable.importance)   # if we want the list of variables in the tree then uncomment this line
mvarlist=unique(c(mvarlist,mvarlist.tree))  # add the variables in the tree that are not in the lr model
evarlist=c()     # vector of extra variables to save -- regardless of whether they are in the model
varlist=c(mvarlist,evarlist)         # vector of variable names that we will use (all model variables plus ID and revenue)
print(varlist)  # vector of variables to save

# retrieve coefficients from your model
coeflist=summary(mdl.lr)$coefficients  # extract coefficients estimates and std errors and z values
coefdata=data.frame(rn=rownames(coeflist),coeflist,row.names=NULL)  # change to dataframe
colnames(coefdata)=c("rn",colnames(coeflist))
print(coefdata)   # print out the coefficients

# set the predictions
prob.lr = predict(mdl.lr,newdata=bank,type='response')
prob.tree = predict(mdl.tree,newdata=bank,type='prob')
prob.tree = prob.tree[,2]   # returns a matrix of predictions, we only want predictions of adopter

# retrieve data about the users (assumes that prob.lr and prob.tree have been computed in earlier part of script)
userpred=cbind(prob.lr[userlist],prob.tree[userlist])  # create matrix of predictions from our model for selected users
colnames(userpred)=c("prob.lr","prob.tree")  # label our columns appropriately
modeldata.all=model.matrix(mdl.lr,data=bank)  # construct the data used in the model
modeldata=modeldata.all[userlist,]  # only keep data for selected userse
userdata=bank[userlist,evarlist]  # get additional variables
userdata=t(cbind(modeldata,userdata,userpred))  # get relevant data for a set of customers
userdata=data.frame(rn=rownames(userdata),userdata,row.names=NULL)  # change to dataframe
print(userdata)   # print out user data

# retrieve averages and std dev across all users
meandata=apply(modeldata.all,2,mean) # compute the average for the selected variables (the "2" means compute by column)
sddata=apply(modeldata.all,2,sd)  # compute the standard deviation for selected variables
descdata=data.frame(rn=names(meandata),meandata,sddata,row.names=NULL)  # merge the vectors with the mean and stddev into a single dataframe
print(descdata)   # print out the descriptive values

# combine the data together to make it easier to dump out to a single spreadsheet
mdata=join(coefdata,descdata,type='full',by='rn')  # merge the coefficients and descriptive stats
mdata=join(mdata,userdata,type='full',by='rn')  # create a final single dataframe
print(mdata)    # print out the combined data

# write the data to a spreadsheet
write.csv(mdata,file="bank_lrmodeldata.csv")   # if you want you can import this file into excel for easier processing