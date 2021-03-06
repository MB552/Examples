### This example is taken from Miller and Blair (1985)

### Example 1

### Suppose a simple economy has two sectors, agriculture and manufacturing

### Agriculture produces $150 value to satisfy its own need, and $500 
### to satisfy manufacturing

### Manufacturing produces $100 value for its own need, and $200 for
### Agriculture.

### Placing this into a sector flow 

### Intermediate flow matrix.

flowtable <- rbind( c( 150 , 500 ), c( 200 , 100 ) )

flowtable
#     [,1] [,2]
#[1,]  150  500
#[2,]  200  100

### row 1 represents the output from Agriculture, which contributes as an
### input to column 1 (Agriculture) and column 2 (Manufacturing).

### In addition to meeting the needs of other areas of the economy
### sectors must also satisfy a consumption demand. Which for each
### sector is the following;

D <- rbind (350,1700)
D
#     [,1]
#[1,]  350
#[2,] 1700

### That is $350 of Agriculture product and $1700 of Manufacturing

inputoutputtable <- cbind(flowtable, D)
inputoutputtable <- as.data.frame(inputoutputtable)
names( inputoutputtable ) <- c("x1" , "x2" , "finaldemand")

### This means that both sectors must meet a total output which is the sum
### of each of these.

inputoutputtable$totaloutput <- inputoutputtable$x1 +
                                inputoutputtable$x2 +
                                inputoutputtable$finaldemand

inputoutputtable
#   x1  x2 finaldemand totaloutput
#1 150 500         350        1000
#2 200 100        1700        2000


totaloutput <- inputoutputtable$totaloutput

### Now we derive the technical coefficient matrix. A column of this matrix 
### represents an industrial recipe used to produce a single industry good.

### We calculate this matrix by dividing intersectoral flows by the total output 
### of each columns sector. 

### For instance, Agriculture ships $500 worth of goods to Manufacturing. 
### Manufacturing produces $2000 of total output. Therefore, one dollar of 
### Agricultural product is absorbed to produce 25 cents of Manufacturing
### product.

### Agriculture ships $500 to Manufacturing, Manufacturing produces $2000 
### overall. Thefore, $500/$2000 = $0.25

### We cant divide matrices in the way we do in usual arithmetic. So we must
### solve the matrix first (find its inverse) and then multiply to obtain the
### comparable result. 

## Calcate coefficient matrix:
z <- ( totaloutput )^-1 * diag( 2 )
A <- flowtable %*% z

# Show A
A
#     [,1] [,2]
#[1,] 0.15 0.25
#[2,] 0.20 0.05

### A shows that to produce the total output of Manufacturing (column 2), 
### it requires 25% of Agricultures total output and 5% of Manufacturing 
### total output.

### Equally, 15% of Agricultures output goes back into Agriculture as an input
### and 20% of Manufacturings output is required back in Agriculture.

### The next step in understanding the network effect and interdependency of
### industries is to calculate the Leontief matrix. 

### First we substract the technical coefficient matrix from the identity matrix.

IminusA <- diag(2) - A

### Calculate the inverse

L <- solve(IminusA)

L
#          [,1]     [,2]
#[1,] 1.2541254 0.330033
#[2,] 0.2640264 1.122112

### This new matrix presents a multiplyer of the relationships between the sectors
### because of the total demand from both. 

### We can now answer the question, how much does each sector need to produce
### if there is a demand shock. 

### Current total demand for both sectors is given by the following vector,

inputoutputtable$finaldemand
#[1]  350 1700

### That is, a demand of 350 from Agriculture and 1700 from manufacturing. 

### If the demand from manufacturing drops to 1500 and agricultural demand increases to 600. How much total output from 
### the two sectors is necessary to meet this demand. 

newdemand <- c(600,1500)

newoutput <- round(L %*% newdemand, digits=2)

newoutput
#        [,1]
#[1,] 1247.52
#[2,] 1841.58

newoutput <- as.vector(newoutput)

(newoutput[1] - totaloutput[1]) / totaloutput[1]
#[1] 0.24752

(newoutput[2] - totaloutput[2]) / totaloutput[2]
#[1] -0.07921

### That is that output for agriculture drops by 23.1% and manufacturing output
### falls by 39.3%. 

### Based on these new final output changes we can reconstruct the intersectoral 
### flows

newoutput.hat <- newoutput*diag(2)

newflowtable <- A%*%newoutput.hat
#        [,1]    [,2]
#[1,] 187.128 460.395
#[2,] 249.504  92.079

### In addition we can introduce the payments sector, these are services paid for 
### by individual sectors and represents labour, government services, interest, 
### rent, profit and so on. 

### This is calculated as the difference between total outputs and industry
### inputs for each sector.

payment_sector <- newoutput - colSums(newflowtable)

### The change in total demand for each sector is the following,

delta.f <- newdemand - inputoutputtable$finaldemand

### the change in intersectoral flows is given by;

### Lf^1 - Lf^0 = L%*%delta.f

delta.x <- L%*%delta.f

### another way of getting to the newoutput figures is by;

x.1 <- totaloutput + delta.x

### Suppose the base-year employment in each sector dvided by that sectors's
### base-year gross output, x1 and x2.

e.hat.prime = cbind(c(0.30, 0),c(0, 0.25))

### The value of labour inputs purchased by the two sectors

epsilon = e.hat.prime %*%newoutput

### Suppose some heterogeneity in labour employment purchased by Agriculture 
### and Manufacturing. 

P = cbind(c(0,0.6,0.4),c(0.8,0.2,0))
#     [,1] [,2]
#[1,]  0.0  0.8
#[2,]  0.6  0.2
#[3,]  0.4  0.0

### Column 1 and 2 represent the proportion of labour types (rows)
### employed in Agriculture and Manufacturing respectively. The rows
### correspond to engineers, bankers and farmers.

### So for instance, in P, 80% of manufacturing input is from engineers. 

epsilon <- as.vector(epsilon)

epsilon.hat <- epsilon*diag(2)

### Quick review of matrix multiplication; in order to multiply and m*n
### matrix by an n*q matrix; the n's must equal one another. 

### epsilon.hat%*%P
### (2*2)%*%(3*2)

### P%*%epsilon.hat
### (3*2)%*%(2*2)

epsilon.tilda <- round(P%*%epsilon.hat, digits=2)

### Economy wide employment of each job role is given by;

Pepsilon <- round(P%*%rowSums(epsilon.hat), digits=2)

### A wide variety of input coefficients can be constructed in this way.

### Example 2

### Consider the same economy, whose 2x2 technical coefficients matrix is given by;

A
#    [,1] [,2]
#[1,] 0.15 0.25
#[2,] 0.20 0.05

### and the project demand vector (f) is given by;

newdemand
#[1]  600 1500

### We will attempt to solve the problem in a more intuitive way this time;

### If we anticipate these final demands on the respective sectors, they can
### not get away with producing less than these amounts.

### Nor can each sector just produce 600 and 1500 since each sector requires an
### input from both itself and the other sector in the economy to function. 

### While the Agricultural sector needs to produce 600, in order to achieve this
### it must take 15% from itself, and 20% from Manufacturing;

### Similarly, the Manufacturing sector has the same issue. We can construct
### the demands, under these circumstances, from the respective sectors as inputs
### by using the technical coefficient matrix, A.

### The required inputs from Agriculture and Manufacturing in order to produce
### the necessary units of Agriculture are as follows;

newdemand[1]*A[,1]

### And for Manufacturing;

newdemand[2]*A[,2]

### That is in order to meet final demand Agriculture needs to produce an extra

(newdemand[1]*A[,1])[1]+(newdemand[2]*A[,2])[1]
#[1] 465

### and Manufacturing;

(newdemand[1]*A[,1])[2]+(newdemand[2]*A[,2])[2]
#[1] 195

### This extra 465 and 195 from Agriculture and Manufacturing respectively, results
### in a further required input from both sectors respectively. This leads to 
### a series of demands required from both sectors, which grow infintesimally 
### smaller with each subsequent round. This is referred to as round-by-round 
### impacts.




