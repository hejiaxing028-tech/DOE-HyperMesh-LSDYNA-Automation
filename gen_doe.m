%%  清空环境变量
warning off             % 关闭报警信息
close all               % 关闭开启的图窗
clear                   % 清空变量
clc                     % 清空命令行

%% 1. DOE采样 （LHS）
nSample = 10;

fpq_F_range = [50, 80];      % 平台力范围
fpq_s_range = [200, 400];    % 行程范围

X = lhsdesign(nSample, 2);

fpq_F_samples = fpq_F_range(1) + (fpq_F_range(2) - fpq_F_range(1)) * X(:,1);
fpq_s_samples = fpq_s_range(1) + (fpq_s_range(2) - fpq_s_range(1)) * X(:,2);

%% 2. 路径设置
hmExe   = 'D:\Program Files\Altair\2022.1\hwdesktop\hm\bin\win64\hmbatch.exe';
tclFile = 'script_doe.tcl';
outDir  = 'F:\huangqi\DOE3';

if ~exist(outDir, 'dir')
    mkdir(outDir);
end

%% 3. 保存DOE参数表
param_table = table( ...
    (1:nSample)', ...
    round(fpq_F_samples, 2), ...
    round(fpq_s_samples, 2), ...
    'VariableNames', {'ID', 'fpq_F', 'fpq_s'});

writetable(param_table, fullfile(outDir, 'DOE_params.xlsx'));

%% 4. 逐工况调用TCL
% =========================
for i = 1:nSample
    
    fpq_F = round(fpq_F_samples(i), 2);
    fpq_s = round(fpq_s_samples(i), 2);
    
   % 写参数文件
    paramFile = 'params.txt';
    fid = fopen(paramFile, 'w');
    fprintf(fid, '%s\n', outDir);   % 第1行：输出目录
    fprintf(fid, '%d\n', i);        % 第2行：caseID
    fprintf(fid, '%.2f\n', fpq_F);  % 第3行
    fprintf(fid, '%.2f\n', fpq_s);  % 第4行
    fclose(fid);

    % 调用 HyperMesh
    cmd = sprintf('"%s" -tcl "%s"', hmExe, tclFile);

    fprintf('开始工况 run__%05d ...\n', i);
    %disp(cmd)

    status = system(cmd);
    
    if status == 0
        fprintf('完成工况 run__%05d\n', i);
    else
        fprintf('失败工况 run__%05d\n', i);
    end
end

disp('全部工况导出完成');

