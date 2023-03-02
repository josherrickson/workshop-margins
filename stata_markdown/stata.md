# Post-estimation command

- Stata "estimation" commands are primarily those which fit models.
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

# Fitting the model

~~~~
<<dd_do>>
regress wage i.race
<</dd_do>>
~~~~

<center>
| Group | Average | &nbsp;&nbsp;&nbsp;&nbsp;| Comparison | Diff. in Averages |
|:-:|:-:|-|:-:|:-:|
| White | <<dd_display:%12.3f e(b)[1,4]>> | | White vs Black | <<dd_display:%12.3f e(b)[1,2]>> |
| Black | ??? | | White vs Other | <<dd_display:%12.3f e(b)[1,3]>> |
| Other | ??? | | Black vs Other | ??? |
</center>

# Calculating group effects and comparisons

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

<center>
| Comparison | Diff. in Averages |
|:-:|:-:|
| White vs Black | <<dd_display:%12.3f e(b)[1,2]>> |
| White vs Other | <<dd_display:%12.3f e(b)[1,3]>> |
| Black vs Other | <<dd_display:%12.3f e(b)[1,3]>> - <<dd_display:%12.3f e(b)[1,2]>> = <<dd_display:%12.3f e(b)[1,3] - e(b)[1,2]>> |
</center>

# Estimated means

`margins` does this for us!

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

# Differences in estimated means

<center>
| Comparison | Diff. In Averages |
|:-:|:-:|
| White vs Black | <<dd_display:%12.3f e(b)[1,2]>> |
| White vs Other | <<dd_display:%12.3f e(b)[1,3]>> |
| Black vs Other | <<dd_display:%12.3f e(b)[1,3]>> - <<dd_display:%12.3f e(b)[1,2]>> = <<dd_display:%12.3f e(b)[1,3] - e(b)[1,2]>> |
</center>

~~~~
<<dd_do>>
margins race, pwcompare
<</dd_do>>
~~~~

# Syntax for estimated means

Average outcome per level

```
margins [categorical variable]
```

Pairwise comparisons between groups

```
margins [categorical variable], pwcompare(ci) // Produce confidence intervals, default
margins [categorical variable], pwcompare(pv) // Produce p-values
```

- Do not preface the categorical variable with `i.`.
- In general, binary (0/1) variables can be treated as continuous or categorical
  in the model. The model is identical either way, but treating them as
  categorical lets `margins` operate in this easy fashion.

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

# Visualization of `margins`

```
margins married
```

![](asobserved.png)

Sometimes called "as observed".

# Choices for ways to handle other covariates

1. As observed (default)
   - Average of predicted outcomes
2. `atmeans`
   - Predicted outcome at average
3. `at` specific values
   - Predicted outcome at specific values
4. Combination (if multiple covariates)

# `atmeans`

~~~~
<<dd_do>>
margins married, atmeans
<</dd_do>>
~~~~

- Means for `married` are ignored since we're requesting at specific values of
`married`.
- As observed and `atmeans` are identical for linear models; but differ for
  generalized linear models (we'll see later).

# Visualization of `margins, atmeans`

```
margins married, atmeans
```

![](atmeans.png)

# `at` specific values

We can manually fix the values of other variables in the model.

```
margins, at(<variable> = (<numlist>) <variable2> = (<numlist>))
```

where `<numlist>` can be any of:

- space-separated list of values (`3 4 .5 -100`)
- integers between range (`2/5` is equivalent to `2 3 4 5`)
- range with step-by instruction (`3(.5)5` is equivalent to `3 3.5 4 4.5 5`)
- any combination of the above (`3 5/7 8(.25)9`)

# `at` specific values example

~~~~
<<dd_do>>
margins married, at(age = (25(5)35))
<</dd_do>>
~~~~

# Visualization of `margins, at(...)`

```
margins married, at(age = (25(5)30))
```

![](atvals.png)

# `at` without categorical variables

We can also use `at` with continuous variables without a categorical variable.

~~~~
<<dd_do>>
margins, at(age = (25(5)30))
<</dd_do>>
~~~~

In this case, `married` is treated just like `age` was in the previous "as
observed" example - held constant.

# Combining these effects

We can combine "as observed"/`atmeans` and `at` when we have multiple
predictors.

~~~~
<<dd_do>>
regress wage i.married age i.south, noheader
<</dd_do>>
~~~~

# Combining these effects, 2

```
regress wage i.married age i.south
```

~~~~
<<dd_do>>
margins married, at(south = (1)) atmeans
<</dd_do>>
~~~~

- Note the use of a categorical variable (`south`) in `at()`.
- Recall that `married`'s means are ignored.

# Estimated slopes

Everything we've done so far is estimating means. We can estimate slopes with
the `dydx` option.

~~~~
<<dd_do>>
regress wage age, noheader
margins, dydx(age)
<</dd_do>>
~~~~

# Non-linear relationships

~~~~
<<dd_do>>
regress wage c.age##c.age, noheader
margins, dydx(age)
<</dd_do>>
~~~~

# Estimated marginal slopes, comments

- This will get a lot more useful when we discuss interactions next.
- Handling additional covariates with "as observed"/`atmeans` or `at` continues
  to work.
- In linear models, "average slope" and "slope at average" are equivalent - not
  true in non-linear models.
- There are additional options such as `eyex` for "elasticities", an extremely
  similar concept in econometrics.

# Instantenous slopes

For non-linear trends, the slope changes across values of the predictor.

<center>
![](picture-tangent-of-parabola.gif)
</center>

(This is also the **tangent**, and is obtained by taking the derivative, which
is often written as $\frac{dy}{dx}$, hence the option `dydx`.)

# Estimating the instantenous slope

```
regress wage c.age##c.age
```

~~~~
<<dd_do>>
margins, dydx(age) at(age = (35 40 45))
<</dd_do>>
~~~~

# Examining interactions

Recall our starting example with a categorical variable and the regression
coefficients only telling part of the story.

~~~~
<<dd_do: quietly>>
regress wage i.race
<</dd_do>>
~~~~

```
regress wage i.race
```

<center>
| Group | Average | &nbsp;&nbsp;&nbsp;&nbsp;| Comparison | Estimate |
|:-:|:-:|-|:-:|:-:|
| White | <<dd_display:%12.3f e(b)[1,4]>> | | White vs Black | <<dd_display:%12.3f e(b)[1,2]>> |
| Black | ??? | | White vs Other | <<dd_display:%12.3f e(b)[1,3]>> |
| Other | ??? | | Black vs Other | ??? |
</center>

When we begin to include interactions in the model, even less useful information
can be extracted via regression coefficients alone.

# Categorical-categorical interaction

~~~~
<<dd_do>>
regress wage i.married##i.race, noheader
<</dd_do>>
~~~~

$3\times2 = 6$ total subgroups, $\binom{6}{2} = 15$ different pairwise
comparisons.

Regression coefficients: 1 subgroup, 5 pairwise comparisons.

# `margins` syntax with interactions

We have a far larger number of useful syntaxes now.

- Average of each level of `married`, averaged across `race`:

    ```
    margins married
    ```

- Average of each unique subgroup of `married` and `race`:

    ```
    margins married#race
    ```

    (Note the single `#` instead of the `##` in the model.)

- Pairwise differences between all unique subgroups:

    ```
    margins married#race, pwcompare(ci) // default
    margins married#race, pwcompare(pv)
    ```

- Average effect of `marriage` within levels of `race`:

    ```
    margins married@race, contrast(ci nowald)
    margins married@race, contrast(pv nowald)
    ```

# Marginal effects

~~~~
<<dd_do>>
margins married
<</dd_do>>
~~~~

# Estimated means in all unique subgroups

~~~~
<<dd_do>>
margins married#race
<</dd_do>>
~~~~

# All pairwise comparisons

~~~~
<<dd_do>>
margins married#race, pwcompare(pv)
<</dd_do>>
~~~~

# Effect of `married` within each `race`

~~~~
<<dd_do>>
margins married@race, contrast(pv nowald)
<</dd_do>>
~~~~

Note the use of `@` rather than `#`.

# `contrast` options

We can run just `margins married@race` without a `contrast` argument but it will
only produce a Wald test table. Switching `married@race` to `race@married`:

~~~~
<<dd_do>>
margins race@married
<</dd_do>>
~~~~

`nowald` option to `contrast` suppresses this table; `pv` or `ci` produce the
estimate table. (So `contrast(ci)` would produce both tables.)

# Effect of `race` within each `married`

~~~~
<<dd_do>>
margins race@married, contrast(pv nowald)
<</dd_do>>
~~~~

Since `race` has more than 2 categories, each comparison is against a reference
category. This isn't a problem if the first variable in the `margins` call is
binary, but is annoying otherwise.

# Displaying all pairwise comparisons within `married` status

~~~~
<<dd_do>>
margins race, at(married = (0)) pwcompare(pv)
<</dd_do>>
~~~~

Repeat for `married = (1)`

# Categorical-continuous interactions

~~~~
<<dd_do>>
regress wage c.age##i.race, noheader
<</dd_do>>
~~~~

<center>
| Group | Slope | &nbsp;| Comparison | Diff. in slopes |
|:-:|:-:|-|:-:|:-:|
| White | <<dd_display:%12.3f e(b)[1,1]>> | | White vs Black | <<dd_display:%12.3f e(b)[1,6]>> |
| Black | ??? | | White vs Other | <<dd_display:%12.3f e(b)[1,7]>> |
| Other | ??? | | Black vs Other | ??? |
</center>

# Estimating marginal slopes in each `race`

~~~~
<<dd_do>>
margins race, dydx(age)
<</dd_do>>
~~~~

# Testing for differences between marginal slopes

~~~~
<<dd_do>>
margins race, dydx(age) pwcompare(pv)
<</dd_do>>
~~~~

# Looking at it the other way

~~~~
<<dd_do>>
margins race, at(age = (35 45))
<</dd_do>>
~~~~

# Testing for differences of marginal means at specific values of `age`

~~~~
<<dd_do>>
margins race, at(age = (35)) pwcompare(pv)
<</dd_do>>
~~~~

If our `at` contains multiple values of `age`, we'll get too many uninteresting
results, so repeat with `margins race, at(age = (45)) pwcompare(pv)`.

# Continuous-continuous interactions

With a continuous-continuous interaction, we generally want to estimate the
slope of one variable at specific values of the other variable.

~~~~
<<dd_do>>
regress wage c.age##c.ttl_exp
<</dd_do>>
~~~~

# Marginal slope at specific values

~~~~
<<dd_do>>
margins, dydx(age) at(ttl_exp = (5(5)15))
<</dd_do>>
~~~~

We can of course reverse the "focal" variable with the "moderator" -`margins,
dydx(ttl_exp) at(age = (35(5)45))`.

# Choosing values of continuous variables

Be sure to choose reasonable values of continuous variables.

~~~~
<<dd_do>>
hist ttl_exp
<</dd_do>>
~~~~

<center>
<<dd_graph: replace>>
</center>

# `marginsplot`

- `marginsplot` is a *post-*post-estimation command
  - You can run it after a `margins` call.
- Any `margins` call with pairwise comparisons (`pwcompare` or using `@`) may
  produce silly results.
- `marginsplot` takes a lot of the standard plotting options. There are a few
  specific options that are useful:
    - `xdim()` defines the x-axis, useful if Stata chooses the wrong by default
    - `recast()` allows us to use a different plot type for the estimates.
    - `recastci()` allows us to use a different plot type for the confidence
      bounds.

# Estimated means

~~~~
<<dd_do>>
quietly regress wage i.race
quietly margins race
marginsplot
<</dd_do>>
~~~~

<center>
<<dd_graph: replace>>
</center>

# Estimated means as bar chart

~~~~
<<dd_do>>
marginsplot, recast(bar)
<</dd_do>>
~~~~

<center>
<<dd_graph: replace>>
</center>

# Interaction plot, categorical-continuous

~~~~
<<dd_do>>
quietly regress wage i.race##c.age
quietly margins race, at(age = (35(5)45))
marginsplot
<</dd_do>>
~~~~

<center>
<<dd_graph: replace>>
</center>

# Interaction plot, continuous-continuous

~~~~
<<dd_do>>
quietly regress wage c.ttl_exp##c.age
quietly margins, at(age = (35(5)45) ttl_exp = (5(5)15))
marginsplot
<</dd_do>>
~~~~

<center>
<<dd_graph: replace>>
</center>

# Switching the x-dimension

~~~~
<<dd_do>>
quietly regress wage c.ttl_exp##c.age
quietly margins, at(age = (35(5)45) ttl_exp = (5(5)15))
marginsplot, xdim(ttl_exp)
<</dd_do>>
~~~~

<center>
<<dd_graph: replace>>
</center>

# `margins` with non-linear models

The `margins` command produces estimates on the scale of the outcome. E.g. for a
logistic regression model, the results are in the probability scale.

~~~~
<<dd_do>>
logit union c.hours##i.married, or nolog
<</dd_do>>
~~~~

# `margins` after `logit`

~~~~
<<dd_do>>
margins married, at(hours = 40)
<</dd_do>>
~~~~

~~~~
<<dd_do: quietly>>
margins married, at(hours = 40) post
<</dd_do>>
~~~~

Thus the model predicts that <<dd_display:%12.2f 100*e(b)[1,1]>>% of unmarried
workers and <<dd_display:%12.2f 100*e(b)[1,2]>>% of married workers have a
positive outcome when working 40 hour weeks.

# `marginsplot` after `logit`

~~~~
<<dd_do: quietly>>
logit union c.hours##i.married, or nolog
<</dd_do>>
~~~~

~~~~
<<dd_do>>
quietly margins married, at(hours = (30 40 50))
marginsplot, recastci(rarea) ciopt(color(%20))
<</dd_do>>
~~~~

<center>
<<dd_graph: replace>>
</center>

# Count models

For Poisson models (or negative binomial), the results are in the count scale.

~~~~
<<dd_do>>
poisson wage i.married##c.hours
<</dd_do>>
~~~~

# `margins` after `poisson`

~~~~
<<dd_do>>
margins married, at(hours = 40)
<</dd_do>>
~~~~

# `marginsplot` after `poisson`

~~~~
<<dd_do>>
quietly margins married, at(hours = (35 40 45))
marginsplot, yscale(range(6 10)) ylabel(6(1)10)
<</dd_do>>
~~~~

<center>
<<dd_graph: replace>>
</center>

# `margins` versus regression coefficients

Of course, in GLMs, the estimated coefficients are not additive on the scale of
the outcome.

- logistic models: odds ratios
- count models: incidence rate ratios

However, `margins` *does* produce results on the outcome scale.

Therefore, `margins` is not an appropriate tool to, for example, obtain odds
ratios between all pairs of groups in a categorical variable.

## Why use `margins` after a non-linear model?

Probabilities and counts are easily to interpret than odds ratios and rate
ratios.

Interaction plots are easier to interpret that regression coefficients.

## If you do want odds ratios...

... use the `nlcom` post-estimation command.

```
logit union i.race
logit, coeflegend
nlcom (white_black: exp(_b[2.race])) (white_other: exp(_b[3.race])) ///
      (black_other: exp(_b[2.race] - _b[3.race]))
```

# Miscellanous things about `margins`

# Other resources

https://errickson.net/marginsnotes/

  - Worked examples of a number of different marginal targets, including code for Stata and R

https://www.stata.com/manuals/rmargins.pdf

  - 58 pages

https://www.stata.com/manuals/rmarginsplot.pdf

  - 35 pages
