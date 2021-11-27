---
title: "Statistical sigginificance in the aggregate sentence lengths of indegenous vs non-indegenuous racial groups"
author: "Mukund Iyer, Yuno Park, Rada Rudyak, Chaoran Wang "
date: "2021/11/26"
always_allow_html: true
output: 
  html_document:
    toc: true
bibliography: sentence_length_race.bib
---


```{r setup, inlude=FALSE}
knitr::opts_chunk$set(echo = FALSE)
library(knitr)
library(kableExtra)
library(tidyverse)
```  

# Summary 

For this project we have carried out a hypothesis test to determine if there is a significant difference in the median sentence lengths between the indigenous and non-indigenous inmates under the Correction Services Canada. The median was selected as the measure of central tendency as the distribution of sentence length for both groups were skewed. Subsequently, a permutation test under the null model was carried out computationally with a significance level of 0.05. The null hypothesis states that there was no difference in the population medians in sentence length between indigenous and non-indigenous inmates. The alternate hypothesis states that there is a difference in the population medians in sentence length between indigenous and non-indigenous inmates. The resulting sample difference in the two medians was `r TEST_STATISTIC`, with a corresponding p-value of `r P_VALUE `. As this p-vaule was greater than the significance level, there was insufficient evidence to reject the null hypothesis. Therefore this study concludes that there is no statistically significant difference in the median jail times between the two groups. Considering the large sample size of `r SAMPLE_SIZE`, there is a small chance that the result is affected by Type 2 error. However, we have to be mindful of the very small effect size. 

# Introduction 

The number of indigenous incarcerations in Canada has increased by 40% in the prison system over the last decade, a faster rate than any other group [@ owusu2014years].  Issues such as increased domestic violence, disruptions in societal structure and norms and health issues are aggravated in highly incarcerated groups [@ freudenberg2001jails]. Hence, these rates are likely to worsen.  

As this population is so vulnerable, the other key factor that should be investigated is if there is a difference in the length of the sentence between the indigenous and non-indigenous groups. This is an important question to infer as it can lead to further studies on the type of charges either group is subject too and whether particular laws disadvantage the indigenous group if a significant difference is found. Additionally, the study could also lead to an exploration of biases present in the current legal system when sentencing. 

# Methods 

## Data 

The data set used for this study is the Offender Profile from 2017-2018 released by the Correctional Service of Canada. The link to this site can be found [here](https://open.canada.ca/data/en/dataset/844ff1e3-e137-41be-9ebe-6bd9843c1a53). Each entry in the dataset corresponds to a single offender serving a two or more year long sentence. The demographic details such as age, gender and marital status at year end are provided for each entry. This was retrieved from the Offender Management System (OMS).

##  Analysis

A hypothesis test with a significance level of 0.05 was carried out to determine if there was a statistically significant difference in the medians of the sentence length between the indigenous and non-indigenous groups. The features used from the data set to complete this analysis were the racial grouping, which was already separated into indigenous and non-indigenous, and aggregate sentence length. The median was selected as the measure of central tendency and the permutation test under the null hypothesis. The null hypothesis stated that there was no difference in the population medians in the sentence length between indigenous and non-indigenous inmates. The alternate hypothesis stated that there was a difference in the population median between indigenous and non-indigenous inmates.

The R and Python programming languages [@R; @Python] and the following R and Python packages were used to perform the analysis:  docopt [@docopt],  knitr [@knitr], tidyverse [@tidyverse], infer[@infer], docopt [@docoptpython]. The code used to perform the analysis and create this report can be found here: https://github.com/UBC-MDS/DSCI_522_inference_on_indigenous_vs_non_indigenous_sentence_length_differences.


# Results and discussion 

Firstly, the only relevant features for our hypothesis test were the ‘aggregate sentence length’ and the ‘racial grouping column’. We decided to use the ‘racial grouping’ column over the race column as it already contained two groups as required by the hypothesis testing: ‘indigenous’ and ‘non-indigenous’. All other columns were dropped. The count of observations in either group was `r COUNT_IND` and `r COUNT_NON_IND`, meaning we had a large enough sample size to carry out a t-test if need be. 

```{r observations_group, echo=FALSE}
knitr::kable(model_quality$table, caption = "Table 1. Number of observations in each group.")
```


To decide what kind of measure of central tendency to apply in our hypothesis test, we looked at the distribution of the sentence lengths of either group (COLORS) using a density plot t. As the distribution for both groups was right skewed, we decided to use the median as our parameter as it is less affected by extreme values as It based on the count.  

```{r groups_sentence_distributions, echo=FALSE, fig.cap="Figure 1. The distribution of the aggregate sentence time of indigenous and non-indigenous inmates.”, out.width = '100%'}

knitr::include_graphics("../results/“DISTRIBUTION.png")
```

Looking at the boxplot, we can see that there is a large overlap in the confidence intervals between the two groups, and potentially indicates that there is not a significant. 

```{r groups_sentence_distributions, echo=FALSE, fig.cap="Figure 2. The distribution of the aggregate sentence time of indigenous and non-indigenous inmates.”, out.width = '100%'}

knitr::include_graphics("../results/“DISTRIBUTION.png")
```

As we selected the median, we subsequently carried out a permutation test under the null hypothesis computationally with `r N_REPEATS`.  This model is applicable as we have a large sample size.

The null hypothesis stated that there is no difference in the median sentence lengths between the indigenous and non-indigenous inmates. The alternate hypothesis stated that there is a difference in the median sentence lengths between the indigenous and non-indigenous populations. The test statistic was the difference in the sample medians of the two groups. The significance level was set to 0.05. 

The distribution under the null hypothesis has the expected normal shape due to the sample size and number of repetitions.

```{r groups_sentence_distributions, echo=FALSE, fig.cap="Figure 3. The null distribution generated using permutation of the difference in medians of the two groups.”, out.width = '100%'}

knitr::include_graphics("../results/“NULL_DISTRIBUTION.png")
```

The difference in the sample test medians was `r DIFF_IN_MEANS`, which corresponded to a p-value of  `r P_VALUE`. As the p-value was greater than the significance level of 0.05, we do not have enough evidence to reject the null hypothesis. Hence there is no statistically significant difference in the median sentence lengths between indigenous and non-indigenous groups. 

```{r observations_group, echo=FALSE}
knitr::kable(model_quality$table, caption = "Table 2. The summary of the hypothesis test”)
```

Though the study revealed that there is no statistical significance, the practical takeaway needs to be assessed in terms of the effect size and sample size. As our samples had such a small difference in the medians, it is likely that the effect size of the test is very small. This increases the risk that we may have committing Type-II error, where we may have missed rejecting the null hypothesis. However, we did have a very large sample size for both groups, which acts as a balance to this small effect size as this reduces the risk of a Type-II error. 

A follow-up study to this could combine the inmates data from multiple years to increase the sample size, and potentially conduct the hypothesis test with a larger alpha value.



# References

