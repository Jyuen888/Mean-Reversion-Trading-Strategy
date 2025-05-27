**Mean-reversion trading strategy using Co-Integration**

Mean reversion is a statistical arbitrage trading strategy where we expect the returns of an asset follows a stationary process and reverts to its long-term mean $\mu$ when returns have diverged significantly away from the mean.

**Stationarity**

Before exploring further, let us first understand what is a stationary process. Suppose we observe a time series (could be stock prices, daily weather, number of people visiting a shopping mall at each hour, etc), the fluctuations of these values appear random, but often there exist the same type of stochastic behavior from one time period to the next (e.g. every Sunday, 12pm, we observed that it is highly likely that the number of visitors are higher than other times). We can use this property, although seemingly random but predictable over the same time window, to predict or estimate future values of the same time window.

Mathematically, a process (which is a series of random variables) is stationary if the its stochastic property is not affected by a change of time origin, that is, if for any time s and t, the probability distribution of a sequence $Y_1,\dots,Y_t$ and  $Y_{1+s},\dots,Y_{t+s}$ are the same, then the process is said to be stationary.

We consider a weakly stationary time series of order $\mathcal{2}$ , that is its mean, variance and covariance structure does not change with time shifts:

- Constant mean $E[Y_t]=\mu$
- Constant variance $var[Y_t]=E[(Y_t-\mu)^2]=\sigma^2$
- Constant autocovariance structure $Corr[Y_s,Y_t]=\rho_{|s-t|}, \ \forall s,t$

The mean and variance do not change with time and the covariance structure (and correlation) between two observations of the time series depend only on the time-lag, of the time distance between the two observations.

Example of non-stationary process:

![image-20250526233122063](/Users/karyuen/Library/Application Support/typora-user-images/image-20250526233122063.png)

Example of a stationary process:

![image-20250526233147078](/Users/karyuen/Library/Application Support/typora-user-images/image-20250526233147078.png)

*Note: These are by no means a formal and rigorous definition of stationarity. Refer to textbooks for more detailed mathematical definition.*

**Mean reversion strategy**

Now that we understand what a stationary process is, we can then search for any stock returns that are stationary and set up a mean-reversion trading strategy as follows:

1. Identify an asset whose returns are stationary
2. Set up a threshold  $\delta$ (e.g. $\delta=\pm (2 \times \sigma)$ ) where $\sigma$ is the standard deviation of the asset returns from its mean
3. When the return of the asset crosses above (below) the threshold +$\delta$ (-$\delta$), then we can long (short) the asset at the prevalent market price.
4. Unwind the position when the asset return crosses below (above) the opposite threshold -$\delta$ (+$\delta$)

We often use asset returns rather than the asset price itself for this mean-reversion strategy as the asset price process are more likely than not non-stationary.

**Co-integration**

Co-integration is the concept of linearly combining 2 different assets to derive a stationary process for our mean-reversion trading strategy, often known as pair-trading strategy. The idea is similar to the case of a 1 asset strategy.

Mathematically, let $x_t,y_t$ be the price returns of two assets. We want to find a $\gamma$ s.t. the portfolio $w_t=x_t+\gamma y_t$ is stationary.

A brief explanation on autoregression. Autoregression (AR) is a regression model where we conduct regression analysis on its own time-lagged variable. For example, let $x_t$ denote the return of an asset at time $t$. Then an AR(1) regression model is $x_t=x_{t-1} + a_t$ where $a_t$ is a white noise with mean 0 and constant variance. Let's extend this further to 2 time series, then we have Vector Autoregression, VAR.

The construction of a portfolio through co-integration is best described with an example. Consider a VAR(1) process:
$$
\begin{bmatrix} x_t \\ y_t \end{bmatrix}= \begin{bmatrix} \frac{1}{2} & -1\\ -\frac{1}{4} & \frac{1}{2} \end{bmatrix} \begin{bmatrix} x_{t-1} \\ y_{t-1} \end{bmatrix} + \begin{bmatrix} a_t \\ b_t \end{bmatrix}
$$
Consider the transformation
$$
w_t=x_t-2y_t , v_t=\frac{1}{2}x_t + y_t , c_t=a_t-2b_t, d_t=\frac{1}{2}a_t+b_t
$$
Then we get that


$$
\begin{bmatrix} w_t \\ v_t \end{bmatrix}= \begin{bmatrix} \frac{1}{2} & -1\\ -\frac{1}{4} & \frac{1}{2} \end{bmatrix} \begin{bmatrix} x_{t-1} \\ y_{t-1} \end{bmatrix} + \begin{bmatrix} a_t \\ b_t \end{bmatrix}
= \begin{bmatrix} x_{t-1}-2y_{t-1} \\ 0 \end{bmatrix} + \begin{bmatrix} c_t \\ d_t \end{bmatrix} = \begin{bmatrix} w_{t-1} \\ 0\cdot v_{t-1} \end{bmatrix}+\begin{bmatrix} c_t \\ d_t \end{bmatrix}
$$
Notice that $w_t=w_{t-1}+c_t$ is a unit-root nonstationary (coefficient of $w_{t-1}=1$) but $v_t=d_t$ is a stationary process. In summary, we applied a transformation and obtained a linear combination of the original time series that is stationary: $v_t=\frac{1}{2}x_t+y_t$. The vector $[\frac{1}{2},1]$ is called a cointegration vector.

**Finding the co-integration vector**

Let's consider again a generic VAR(1) model
$$
\boldsymbol{x_t}=\phi_0+\boldsymbol{\Phi}\boldsymbol{x_{t-1}}+\mathbf{a_t}
$$
We want to obtain a linear transformation $\mathbf{y_t}=L \mathbf{x_t}$ , applying to our VAR(1) model, we get that
$$
\begin{align}
\boldsymbol{y_t}&=L\phi_0+L\boldsymbol{\Phi}\boldsymbol{x_{t-1}}+L\mathbf{a_t} \\
&= L\phi_0+L\boldsymbol{\Phi}L^{-1}\boldsymbol{y_{t-1}}+L\mathbf{a_t}
\end{align}
$$
Suppose $L\boldsymbol{\Phi}L^{-1}=\begin{bmatrix} \boldsymbol{\Phi_1} & 0\\ 0 & \boldsymbol{\Phi_2} \end{bmatrix}$ is a block diagonal matrix, where $\rho(\boldsymbol{\Phi_1})<1$ and $\rho(\boldsymbol{\Phi_2})=1$ and $\rho(\cdot)$ denotes the eigenvalues of any matrix.

We use Jordan diagonalization to obtain the block diagonal matrix $L\boldsymbol{\Phi}L^{-1}=\begin{bmatrix} \boldsymbol{\Phi_1} & 0\\ 0 & \boldsymbol{\Phi_2} \end{bmatrix}=J$.

In Jordan normal form, $\boldsymbol{\Phi}=L^{-1}JL$ where the rows of L correspond to left eigenvectors of $\boldsymbol{\Phi}$ . The steps to find the matrix L is thus:

1. Find eigenvalues $\lambda_i$ of $\boldsymbol{\Phi}$ s.t. $det(\lambda_i I - \boldsymbol{\Phi)})=0$
2. Find eigenvectors $v_i^T$ s.t. $v_i^T \boldsymbol{\Phi}=\lambda_i v_i^T$ 
3. Arrange the $k$ distinct eigenvalues from smallest to largest into a diagonal matrix, $J=diag\{\lambda_1, \lambda_2, \dots, \lambda_k \}$ where $\lambda_1 < \lambda_2< \dots \lambda_k$
4. Arrange the left eigenvector matrix $L=[v_1,\dots ,v_k]^T$ where the rows of L correspond to left eigenvectors of $\boldsymbol{\Phi}$, in other words, the first row of L correspond to eigenvector $v_1^T$, second row of L correspond to eigenvector $v_2^T$ and so on until the last eigenvector $v_k^T$ corresponding to the largest eigenvalue $\lambda_k$.

Now that we have the matrix $L$ s.t. $L\boldsymbol{\Phi}L^{-1}=\begin{bmatrix} \boldsymbol{\Phi_1} & 0\\ 0 & \boldsymbol{\Phi_2} \end{bmatrix}=J$, substituting into our transformed VAR(1) model gives us
$$
\begin{align}
\boldsymbol{y_t}&= L\phi_0+L\boldsymbol{\Phi}L^{-1}\boldsymbol{y_{t-1}}+L\mathbf{a_t} \\
&= L\phi_0+J\boldsymbol{y_{t-1}}+L\mathbf{a_t}
\end{align}
$$
Expanding each rows individually, we get that (for example):
$$
y_{1,t}=v_1^T \phi_0 + \lambda_1 y_{t-1}+v_1^Ta_{1,t}
$$
which is the same as multiplying the original VAR(1) model with the eigenvector $v_1^T$:
$$
y_{1,t}=v_1^T \boldsymbol{x_t}=v_1^T \phi_0 + v_1^T\boldsymbol{\Phi} \boldsymbol{x_{t-1}}+v_1^T\boldsymbol{a_{t}}=v_1^T \phi_0 + \lambda_1 y_{t-1}+v_1^Ta_{1,t}
$$
$y_{1,t}$ is an AR(1) process with $\lambda_1<1$, so it is a stationary process.

The corresponding eigenvector $v_1^T$ is our co-integration vector

**Construction of trading portfolio using co-integration**

We build a trading portfolio using eigenvectors corresponding to eigenvalues less than 1:
$$
\Pi_t=v_1^T \boldsymbol{x_t}=v_1^{(1)}x_{1,t}+v_1^{(2)}x_{2,t}+\dots + v_1^{(n)}x_{n,t}
$$
for $\boldsymbol{x_t} \in \mathbb{R}^{n \times 1}$.

We find the mean and standard deviation of the portfolio $\Pi_t$ and set up a trading strategy as mentioend above.