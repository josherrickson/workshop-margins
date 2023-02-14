^#^ Introduction

- `margins` as a postestimation command
- "Margins are statistics calculated from predictions of a previously fit model
at fixed values of some covariates and averaging or otherwise integrating over
the remaining covariates."


^#^ Categorical variables

~~~~
<<dd_do>>
sysuse auto
regress price i.rep78
margins rep78
<</dd_do>>
~~~~
