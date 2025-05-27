######## Question 4############
set.seed(99)
z1 = rnorm(1000)
z2 = rnorm(1000)
z3 = rnorm(1000)
a1 = z1
a2 = 0.2*z1 + sqrt(0.96)* z2
a3 = 0.24/sqrt(0.96) * z2 + sqrt(1-0.06)* z3
r1 = rep(0, 1000)
r2 = rep(0, 1000)
r3 = rep(0, 1000)
pt = rep(0,1000)
for (t in 2:1000) {
  r1[t] = 0.6 * r1[t-1] - 0.3 * r2[t-1] + 0.1 * r3[t-1] + a1[t]
  r2[t] = -0.4 * r1[t-1] + 0.2 * r2[t-1] - 0.4 * r3[t-1] + a2[t]
  r3[t] = 0.4 * r1[t-1] + 0.3 * r2[t-1] + 0.9 * r3[t-1] + a3[t]
  pt[t] = 0.866 * r1[t] + 1.7321 * r2[t] + 0.866 * r3[t]
  }

plot(pt,type="l",col="blue")

threshld=1
position=0
profit_long=0
entry=0
exit=0
mu=mean(pt)
#Long positions
for (i in 1:1000)
  {if (pt[i]<=mu-threshld & position==0)
    {position=1
    entry=pt[i]
    }
    else if ((pt[i]>=mu-threshld & position==1))
    {position=0
    exit=pt[i]
    profit_long=profit_long+exit-entry
    }
  }
#Short positions
profit_short=0
threshld=0.1
position=0
entry=0
exit=0
mu=0
for (i in 1:1000)
  {if (pt[i]>=mu-threshld & position==0)
    {position=1
    entry=pt[i]
    }
  else if ((pt[i]<=mu-threshld & position==1))
    {position=0
    exit=pt[i]
    profit_short=profit_short+entry-exit
    }
  }
print(paste("Long positions profit is ",profit_long))
print(paste("Short positions profit is ",profit_short))
print(paste("Total profit is ",profit_long+profit_short))

plot(pt,type="l",col="blue")
abline(h=0.1,col="red",lty=2)
abline(h=-0.1,col="red",lty=2)
abline(h=0.2,col="red",lty=2)
abline(h=-0.2,col="red",lty=2)
abline(h=0.5,col="red",lty=2)
abline(h=-0.5,col="red",lty=2)
abline(h=1,col="red",lty=2)
abline(h=-1,col="red",lty=2)
