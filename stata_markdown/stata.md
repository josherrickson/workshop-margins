# Post-estimation command

- Stata "estimation" commands are primarly those which fit models.
    - E.g. `regress`, `logit`, `mixed`, `xtreg`.
- Stata "stores" the most recent estimation command.
- `margins` is a post-estimation command; meaning it will use the most recently
  run estimation.
- `margins` itself is *not* an estimation command

# Categorical variables

~~~~
<<dd_do>>
sysuse nlsw88
list in 1
<</dd_do>>
~~~~

---

~~~~
<<dd_do>>
regress wage i.race
<</dd_do>>
~~~~

<center>
| Group | Average | &nbsp;&nbsp;&nbsp;&nbsp;| Comparison | Estimate |
|:-:|:-:|-|:-:|:-:|
| White | <<dd_display:%12.3f e(b)[1,4]>> | | White vs Black | <<dd_display:%12.3f e(b)[1,2]>> |
| Black | ??? | | White vs Other | <<dd_display:%12.3f e(b)[1,3]>> |
| Other | ??? | | Black vs Other | ??? |
</center>

---

~~~~
<<dd_do>>
regress, noheader
<</dd_do>>
~~~~

$$
wage = \beta_0 + \beta_1\textrm{Black} + \beta_2\textrm{Other} + \epsilon
$$

<center>
| Group | Average |
|:-:|:-:|
| White | <<dd_display:%12.3f e(b)[1,4]>> |
| Black | <<dd_display:%12.3f e(b)[1,4]>> + <<dd_display:%12.3f e(b)[1,2]>> = <<dd_display:%12.3f e(b)[1,4] + e(b)[1,2]>> |
| Other | <<dd_display:%12.3f e(b)[1,4]>> + <<dd_display:%12.3f e(b)[1,3]>> = <<dd_display:%12.3f e(b)[1,4] + e(b)[1,3]>> |
</center>

&nbsp;

<center>
| Comparison | Estimate |
|:-:|:-:|
| White vs Black | <<dd_display:%12.3f e(b)[1,2]>> |
| White vs Other | <<dd_display:%12.3f e(b)[1,3]>> |
| Black vs Other | <<dd_display:%12.3f e(b)[1,2]>> - <<dd_display:%12.3f e(b)[1,3]>> = <<dd_display:%12.3f e(b)[1,2] - e(b)[1,3]>> |
</center>

# `margins` does this for you!

<center>
| Group | Average |
|:-:|:-:|
| White | <<dd_display:%12.3f e(b)[1,4]>> |
| Black | <<dd_display:%12.3f e(b)[1,4]>> + <<dd_display:%12.3f e(b)[1,2]>> = <<dd_display:%12.3f e(b)[1,4] + e(b)[1,2]>> |
| Other | <<dd_display:%12.3f e(b)[1,4]>> + <<dd_display:%12.3f e(b)[1,3]>> = <<dd_display:%12.3f e(b)[1,4] + e(b)[1,3]>> |
</center>

~~~~
<<dd_do>>
margins race
<</dd_do>>
~~~~

# `margins` does this for you!

<center>
| Comparison | Estimate |
|:-:|:-:|
| White vs Black | <<dd_display:%12.3f e(b)[1,2]>> |
| White vs Other | <<dd_display:%12.3f e(b)[1,3]>> |
| Black vs Other | <<dd_display:%12.3f e(b)[1,2]>> - <<dd_display:%12.3f e(b)[1,3]>> = <<dd_display:%12.3f e(b)[1,2] - e(b)[1,3]>> |
</center>

~~~~
<<dd_do>>
margins race, pwcompare
<</dd_do>>
~~~~

# Syntax for categorical variables.

Average outcome per level

```
margins [categorical variable]
```

Pairwise comparisons between groups

```
margins [categorical variable], pwcompare(ci) // Produce confidence intervals
margins [categorical variable], pwcompare(pv) // Produce p-values
```

- Do not preface the categorical variable with `i.`.
- In general, binary (0/1) variables can be treated as continuous or
  categorical. Model is identical either way, but treating as categorical lets
  `margins` operate in this easy fashion.

# In the presence of covariates

~~~~
<<dd_do>>
regress wage age i.married, noheader
<</dd_do>>
~~~~

~~~~
<<dd_do>>
margins married
<</dd_do>>
~~~~

# Setting values of other covariates, 1

```
margins [categorical variable]
```

![](asobserved.png)

Sometimes called "as observed".

# Setting values of other covariates, 2

## `atmeans`

~~~~
<<dd_do>>
margins married, atmeans
<</dd_do>>
~~~~

- Means for `married` are ignored since we're requesting at specific values of
`married`.
- As observed and `atmeans` are identical for linear models; but differ for
  generalized linear models (we'll see later).

# Setting values of other covariates, 3

```
margins [categorical variable], atmeans
```

![](atmeans.png)

# Setting values of other covariates, 4

## `at`

You can manually fix the values of other variables in the model.

```
margins, at(<variable> = (<numlist>) <variable2> = (<numlist))
```

where `<numlist>` can be any of:

- space-separated list of values (`3 4 .5 -100`)
- integers between range (`2/5` is equivalent to `2 3 4 5`)
- range with step-by instruction (`3(.5)5` is equivalent to `3 3.5 4 4.5 5`)
- any combination of the above (`3 5/7 8(.25)9`)

# Setting values of other covariates, 5

~~~~
<<dd_do>>
margins married, at(age = (25(5)35))
<</dd_do>>
~~~~
