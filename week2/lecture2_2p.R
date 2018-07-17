# Problem Set 2 Solution Template
# mysoln is a list to store your answers

# the first element of the list is a vector of names for the students in your group
# make sure these match the names shown on the pdf document provided by the MFE office
# using group 1 as an example:
mysoln = list(student = c("Molin Liang", "Meghana Rao", "Chengbo Du", "Shardul Kulkarni"))

# 1

# your intermediary code to get your answers here

# save down your final answers for part a, b, and c
a = c(price,ytm) #ytm in decimal form
b = c(price,ytm) #ytm in decimal form
c = c(price,ytm) #ytm in decimal form

# add answers to list for "Q1"
mysoln[["Q1"]] = list(a=a, b=b, c=c)

# 2

# your intermediary code to get your answers here

# save down your final answers
a = c(r.6month, r.1yr) #in decimal form

# add answers to list for "Q2"
mysoln[["Q2"]] = list(a=a)

# 3

# your intermediary code to get your answers here

# answers
a = c(priceA,priceB,priceC)
#b = "Put in PDF writeup

# add answers to list for "Q3"
mysoln[["Q3"]] = list(a=a)


# 4

# your intermediary code to get your answers here

# save down your final answers for part a, b, and c
a = c(price,ytm) #ytm in decimal form
b = c(0,0,0) #adjust vector for number of forward rates
c = return.3yr #add explanation for c to PDF

# add answers to list for "Q4"
mysoln[["Q4"]] = list(a=a, b=b, c=c)

# 5

# your intermediary code to get your answers here

# answers
#a = "Put in PDF Writeup"
b = forward.rate #in decimal form
#c = "Put in PDF Writeup"

# add answers to list for "Q5"
mysoln[["Q5"]] = list(b=b)

# return my solution
mysoln


