
# Cognitive2Computation
[![LinkedIn](https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555)](https://www.linkedin.com/in/yufang-w-1295881b5/) [![GitHub](https://img.shields.io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white&colorB=555)](https://github.com/Yufanggg) <img alt="GitHub" src="https://img.shields.io/github/license/bopith/UnicornCompanies?style=for-the-badge"> 

## Overview
This repository contains the stimulated power analysis under linear mixed modelling setting, TFCE under linear mixed modelling setting. 

This project is updated from codes used in my PhD work (from cognition to computation: an insight from word production) and aims to address the following research related questions:
1. How to calculate the sample size in the experimental design with two fully-crossed random variables (e.g., within subject and within target word experimental design).
2. How to extract the relationship of word patterns from a large-scale corpus?
3. How to conduct the testing for datasets under high-dimensional setting (e.g., EEG data)?


## Table of Contents

- [Experimental Design](#ExperimentalDesign)
- [Installation](#installation)
- [Data](#Data)
- [Project Structure](#project-structure)
- [Results](#Results)

## Requirments
To run this Project, you will need the following:
- Python (> 3.6)
- Pandas (pip install pandas)
- Requests (pip install requests)
- SQLAlchemy (pip install sqlalchemy)

## Installation

## Experimental Design

### Power Analysis
With a given experimental materials, a [Power Analysis](./DOE.Rmd) was conducted to validate the number of participants. See the an example result for 2-by-2 experimental design within subject and target word (which are fully crossed) as following: 
![alt text](./Images/PowerCurve.jpg)

## Data Analysis
### Behavioral Data Analysis
### EEG data Analysis

