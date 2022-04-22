function project_num = generate_project_info_save(exp_records_filename,est_info_proj,project_num)
%make sure the file .mat exists before running

MonolixListTable = readtable(exp_records_filename,'Sheet','MonolixProjects');

if ~isfile('./MonolixProjectInfo.mat')
    disp('MonolixPrejectInfo.mat dose not exist on the current folder, will generate an empty one.') 
    est_info=cell(1,1);
    save('MonolixProjectInfo.mat','est_info');
    clear est_info
end

load('MonolixProjectInfo.mat','est_info')

if ~isfield(est_info_proj.model,'sti_lag')
    est_info_proj.model.sti_lag = 0;
end

est_info{project_num} = est_info_proj;

[cl ~] = clock;
time_curr = strcat(num2str(cl(1)),'/',num2str(cl(2)),'/',num2str(cl(3)),'-',num2str(cl(4)),':',num2str(cl(5)));

newInsect = table({project_num },{est_info_proj.proj_name},{est_info_proj.model.filename},{est_info_proj.data.filename},{est_info_proj.model.sti_lag},{time_curr});


if project_num <= max(MonolixListTable.ProjectNum)
    warning(strcat('replacing an existed project! ',est_info_proj.proj_name))

    corner_st=strcat('A',num2str(project_num+1));
    
    writetable(newInsect,'InSilicoExperimentsList.xlsx','Range',corner_st,...
    'WriteVariableNames',false,'WriteRowNames',true)
else
writetable(newInsect,'InSilicoExperimentsList.xlsx','WriteMode','Append',...
    'WriteVariableNames',false,'WriteRowNames',true)
end

%% fix!!!
save('MonolixProjectInfo.mat','est_info');

save(strcat(est_info_proj.proj_path,'ProjectInfo.mat'),'est_info_proj');

