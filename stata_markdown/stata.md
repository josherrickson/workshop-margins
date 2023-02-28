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
regress wage i.race ttl_exp
<</dd_do>>
~~~~
<center>
| Comparison | Estimate |
|:-:|:-:|
| White vs Black | <<dd_display:%12.3f e(b)[1,2]>> |
| White vs Other | <<dd_display:%12.3f e(b)[1,3]>> |
| Black vs Other | ??? |
</center>
