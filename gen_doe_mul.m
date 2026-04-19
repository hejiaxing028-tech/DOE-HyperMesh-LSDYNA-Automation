%% 清空环境变量
warning off
close all
clear
clc

%% 1. DOE采样（LHS）
nSample = 10;

% =====================================================
% 统一在这里定义参数名和范围
% 顺序必须和 Tcl 读取顺序一致
% =====================================================
paramNames = {'fpq_F', 'fpq_s'};

paramRanges = [
    500   800;    % fpq_F
    200   400];    % fpq_s


nParam = size(paramRanges, 1);

% LHS采样
X = lhsdesign(nSample, nParam);

% 映射到真实参数范围
samples = zeros(nSample, nParam);
for j = 1:nParam
    low  = paramRanges(j, 1);
    high = paramRanges(j, 2);
    samples(:, j) = low + (high - low) * X(:, j);
end

% 保留两位小数
samples = round(samples, 2);

%% 2. 路径设置
hmExe   = 'D:\Program Files\Altair\2022.1\hwdesktop\hm\bin\win64\hmbatch.exe';
tclFile = 'script_doe.tcl';
outDir  = 'E:\matlab_tcl\DOE4';

if ~exist(outDir, 'dir')
    mkdir(outDir);
end

%% 3. 保存DOE参数表
ID = (1:nSample)';
param_table = array2table(samples, 'VariableNames', paramNames);
param_table = addvars(param_table, ID, 'Before', 1);

writetable(param_table, fullfile(outDir, 'DOE_params.xlsx'));

%% 4. 逐工况调用TCL
for i = 1:nSample
    
    % 当前工况所有参数
    caseParams = samples(i, :);
    
    % 写参数文件
    paramFile = 'params.txt';
    fid = fopen(paramFile, 'w');
    if fid == -1
        error('无法打开参数文件: %s', paramFile);
    end

    fprintf(fid, '%s\n', outDir);   % 第1行：输出目录
    fprintf(fid, '%d\n', i);        % 第2行：caseID

    % 第3行开始：按 paramNames 顺序自动写入
    for j = 1:nParam
        fprintf(fid, '%.2f\n', caseParams(j));
    end

    fclose(fid);

    % 调用 HyperMesh
    cmd = sprintf('"%s" -tcl "%s"', hmExe, tclFile);

    fprintf('开始工况 run__%05d ...\n', i);

    status = system(cmd);
    
    if status == 0
        fprintf('完成工况 run__%05d\n', i);
    else
        fprintf('失败工况 run__%05d\n', i);
    end
end

disp('全部工况导出完成');