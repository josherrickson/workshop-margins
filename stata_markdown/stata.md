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

---


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

```
margins [categorical variable]
margins [categorical variable], pwcompare(ci) // Produce confidence intervals
margins [categorical variable], pwcompare(pv) // Produce p-values
```

- Do not preface the categorical variable with `i.`.
- In general, binary (0/1) variables can be treated as continuous or
  categorical. Model is identical either way, but treating as categorical lets
  `margins` operate in this easy fashion.

Multiple categorical variables?
