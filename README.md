# DOE HyperMesh Automation

This project automates DOE sample generation in MATLAB and batch model export in HyperMesh using TCL scripts.

## Features

- Latin Hypercube Sampling (LHS) for parameter generation
- Automatic export of DOE parameter table to Excel
- Batch execution of HyperMesh through `hmbatch.exe`
- Automatic creation of case folders such as `run__00001`, `run__00002`, etc.

## Project Structure

```text
DOE_HyperMesh_Automation/
├─ main_doe_export.m
├─ script_doe.tcl
├─ README.md
├─ .gitignore
├─ input/
├─ output/
└─ docs/