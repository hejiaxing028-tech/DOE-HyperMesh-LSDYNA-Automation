# 🚀 MATLAB–HyperMesh DOE Automation Framework

## 📌 Overview

This project provides an automated workflow that integrates:

* **MATLAB** for Design of Experiments (DOE) using **Latin Hypercube Sampling (LHS)**
* **HyperMesh (Tcl scripting)** for parametric model generation
* Batch processing for exporting LS-DYNA keyword files

The framework enables efficient generation of multiple simulation cases by automatically:

1. Sampling design parameters
2. Writing parameters to a file (`params.txt`)
3. Calling HyperMesh in batch mode
4. Generating structured output folders and `.k` files

---

## 🧠 Key Features

* ✅ LHS-based DOE sampling
* ✅ Fully automated MATLAB → HyperMesh workflow
* ✅ Flexible parameter definition (scalable to multiple variables)
* ✅ Automatic folder creation (`run__00001`, etc.)
* ✅ Excel export of DOE table
* ✅ Easy integration with LS-DYNA batch solving

---

## 📁 Project Structure

```
project_root/
│
├── main.m                 # MATLAB 主脚本（DOE + 调用 HyperMesh）
├── script_doe.tcl         # HyperMesh Tcl 自动建模脚本
├── params.txt             # MATLAB 写入，Tcl 读取
├── DOE_params.xlsx        # DOE 参数表（自动生成）
│
├── run__00001/            # 每个工况自动生成
│   └── qiang041502.k
│
├── run__00002/
│   └── qiang041502.k
│
└── README.md
```

---

## ⚙️ Requirements

### Software

* MATLAB (R2018+ recommended)
* Altair HyperMesh (2022.1 or compatible)
* LS-DYNA (optional, for simulation)

### Environment

Make sure the following paths are correctly configured:

```matlab
hmExe = 'D:\\Program Files\\Altair\\2022.1\\hwdesktop\\hm\\bin\\win64\\hmbatch.exe';
```

---

## 🧪 Parameters Definition

All design variables are defined in MATLAB:

```matlab
paramNames = {'fpq_F', 'fpq_s'};

paramRanges = [
    500   800;    % fpq_F
    200   400     % fpq_s
];
```

* The **order must match Tcl reading order**
* Easily extendable to more variables

---

## 🔄 Workflow

### Step 1 — DOE Sampling

* Use LHS to generate `nSample` parameter combinations
* Map samples to physical ranges
* Save to:

```
DOE_params.xlsx
```

---

### Step 2 — Parameter Transfer

For each case:

MATLAB writes:

```
params.txt
```

Format:

```
outDir
caseID
param1
param2
...
```

---

### Step 3 — HyperMesh Execution

MATLAB calls:

```bash
hmbatch.exe -tcl script_doe.tcl
```

Tcl script will:

* Read parameters
* Create directory: `run__00001`
* Modify model
* Export `.k` file

---

### Step 4 — Output

Generated automatically:

```
E:\\matlab_tcl\\DOE4\\
│
├── DOE_params.xlsx
├── run__00001\\
├── run__00002\\
...
```

---

## ▶️ How to Run

### 1. Clone the repository

```bash
git clone https://github.com/yourname/DOE-HyperMesh-Automation.git
cd DOE-HyperMesh-Automation
```

### 2. Modify paths in MATLAB

```matlab
outDir  = 'E:\\matlab_tcl\\DOE4';
hmExe   = 'D:\\Program Files\\Altair\\...\\hmbatch.exe';
```

### 3. Run MATLAB script

```matlab
main
```

### 4. Check output

* DOE table
* Generated `.k` files
* Log messages

---


## 🧩 Extending the Framework

This framework can be extended to:

* 🔹 Multi-objective optimization (MODE / NSGA-II)
* 🔹 Surrogate modeling (MLP, LSTM, TCN)
* 🔹 LS-DYNA batch solving
* 🔹 Data-driven crash analysis

---


## ⭐ Acknowledgement

This project supports:

* Parametric FE modeling
* DOE-driven optimization workflows
