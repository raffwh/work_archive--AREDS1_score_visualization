<head>
    <title>Line </title>
    <style>
        /* Style for a dark horizontal line */
        .top-line {
            border: none;              /* Remove default border */
            height: 4px;               /* Thickness of the line */
            background-color: #000000; /* Black color */
            margin: 20px 0;            /* Space above and below */
        }
        .dark-line {
            border: none;              /* Remove default border */
            height: 1px;               /* Thickness of the line */
            background-color: #000000; /* Black color */
            margin: 20px 0;            /* Space above and below */
        }
    </style>
</head>





<hr class="top-line" >



# AREDS Severity Scale Visualization

> A custom visualization I developed to visualize
> Some issues in AREDS 1 severity scale 
> that affected our analysis.



<div align='center'>

![R](https://img.shields.io/badge/R-4.0-276DC3?style=flat-square&logo=r&logoColor=white)
![ggplot2](https://img.shields.io/badge/ggplot2-276DC3?style=flat-square&logo=r&logoColor=white)

![Status](https://img.shields.io/badge/Status-Archived-lightgrey?style=flat-square)
![Type](https://img.shields.io/badge/Type-Research%20Work-blueviolet?style=flat-square)
</div>



<hr class="dark-line">




## REPO OBJECTIVE

This repo is a snippet for the R code to create the visualization in Supplemental Figure 1 in: <b>Seddon et al. Rare and Common Genetic Variants, Smoking, and Body Mass Index: Progression and Earlier Age of Developing Advanced Age-Related Macular Degeneration (2020).</b> 
[(PUBMED LINK)](https://pubmed.ncbi.nlm.nih.gov/33369641/)



## GRAPH PREVIEW

![Visualization](./sevscale_supFig_year_20201113_g.tiff)


---


## BACKGROUND / OVERVIEW

### AREDS **1** overview

AREDS was a multiyear longitudinal clinical trial on age-related macular degeneration, looking to see the effect of supplements on the progression of the disease. During the first AREDS trial, the grading system utilized 9 steps plus progression to the advanced AMD. 

Many papers have been published and explained the trial design and results. So I won't go into details here.


--

### Research Objective

While many studies now used the simplified scale, we used the full scale to create a more granular analysis on the time-based progression of the disease.

- **Severity scale 1-8**: was for the non-advanced AMD grade.

- **Severity scale 9**: was for the advanced AMD grade.

- **modified severity scale 9, to include 10, 11, 12**: was our modification to include GA and NV as part of the continuous scale. 


### Story

- Since we analyzed it in very granular level, we hit an issue where the count of advanced AMD was different between timepoints.

- Upon further investigation, we found that there were many cases where an eye was graded as progressed to advanced stage 
but then went back to non-advanced stage. 

- Since we wanted to analyze this progression like survival analysis, we had to make sure that a progressed eye should not go back to non-advanced stage. 

    - In some cases, the advanced grade only occured once in the middle of the study period and then back to very early stage (scale <6).
    - In other cases, the time when the eye progressed to advanced stage occurred multiple times. 

- So, we developed a criteria to only select the eye as progressed eye, when the grade or status had passed the progression status/scale, at least at 2 time points in a sequence. 


- Then we realized the system was quite abstract.

> - So, I developed a visualization to show the progression and the flip flopping issue.






## CODE

| Tool | Purpose |
|------|---------|
| R | main code |
| ggplot2 | Data visualization package |
| SAS* | Data preparation (not in this repo) |



I put my code here, mostly for the visualization part of this project as this is my main analysis contribution. 
Since AREDS data, while public, requires credential and research proposal, I cannot put the data here. 



---

## OTHER VERSION

![GRAPH](./sevscale_supFig_visit_20200730_a.tiff)



## Acknowledgements
Dr. Johanna Seddon and Dr. Bernard Rosner

## Citation
    Seddon JM, Widjajahakim R, Rosner B. Rare and Common Genetic Variants, Smoking, and Body Mass Index: Progression and Earlier Age of Developing Advanced Age-Related Macular Degeneration. Invest Ophthalmol Vis Sci. 2020;61(14):32. doi:10.1167/iovs.61.14.32




<p align="right"><i>Archived · Research Work · [2020]</i></p>
