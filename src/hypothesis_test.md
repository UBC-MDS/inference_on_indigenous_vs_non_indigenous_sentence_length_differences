Hypothesis Testing of Offender Profile data set
================

## Define the statistic we are interested in

We are interested in inferring if there is a statistically significant
difference in the length of sentences between indigenous and
non-indigenous offenders in the Correctional Services of Canada. Based
on the previous EDA work, we can see the distribution of the length of
sentences is strongly skewed for both indigenous and non-indigenous
offenders. Besides, we have two independent samples of observations for
two groups. Therefore, we choose the difference of medians of the length
of sentences to be our interested statistics because it is more robust
than the mean for the skewed data set.

## The hypotheses and test statistic

We set the hypotheses as following:

*H*<sub>0</sub>: The median length of sentences of indigenous group,
*M*<sub>1</sub>, is equal to the median length of sentences of
non-indigenous group, *M*<sub>2</sub>.

*H*<sub>*A*</sub>: The median length of sentences of indigenous group,
*M*<sub>1</sub>, is equal to the median length of sentences of
non-indigenous group, *M*<sub>2</sub>.

Test statistic: *M̂*<sub>1</sub> − *M̂*<sub>2</sub>.

## Method of hypothesis test

Since we choose the difference of medians to be our interest statistic,
we will use the permutation test here.

## Result from hypothesis test for the difference in medians

![](hypothesis_test_files/figure-gfm/hypothesis_plot-1.png)<!-- -->

Figure 1. Distribution of null hypothesis for the difference in medians
for Indigenous vs. Non Indigenous offenders

| diff in means | p_value |
|--------------:|--------:|
|           -56 |  0.0328 |

Table 1. p-value from hypothesis test

Since the test statistic falls in the left tail in the distribution plot
and the *p*-value  = 0.0328 \< 0.05, we can conclude that given the
significant level of *α* = 0.05, there is statistically significant
evidence that we can reject *H*<sub>0</sub> such that there is
significant difference in the length of sentences between indigenous and
non-indigenous offenders in the Correctional Services of Canada.
