
% the basic info should be specified for different project
% specify model and data

%% basic info
% data info
clear all

% the project number. this can be comment out , the codes can read the
% newest project automatically.
set_proj_num = 28;

% the filename for saving all project informations
exp_records_filename = 'InSilicoExperimentsList.xlsx';


% porject infos
sti_ligand = 'TNF';

data_info.ligand_vec = {sti_ligand,sti_ligand,sti_ligand};
data_info.dose_index_vec = {1,2,3};
% data_info.cell_num_vec = {100,100,100};
data_info.SAEM_ending_time_mins_vec = {480,480,480}; %min
est_info_proj.model.est_para_receptor = {'params54','params53'};


% model info
est_info_proj.model.est_para_core = {'params66','params101'};
est_info_proj.model.est_receptor = sti_ligand;
est_info_proj.model.est_para_default = {'NFkB_cyto_init','shift'};
est_info_proj.model.est_para_core = {'params66','params99','params100','params101'};
est_info_proj.model.est_para = [est_info_proj.model.est_para_core(:)', est_info_proj.model.est_para_receptor(:)',est_info_proj.model.est_para_default(:)'];%


% estimation info
est_info_proj.est.para_range_set = cell(size(est_info_proj.model.est_para));
est_info_proj.est.distribution_type = cell(size(est_info_proj.model.est_para));


%% 0. name the project [done]

data_info.filename = 'data_example.txt';
est_info_proj.data = data_info;

if exist('set_proj_num','var')
    proj_num = set_proj_num;
else
    proj_num = get_latest_project_num(exp_records_filename) +1; % to be fixed!!! est_info_proj.est.para_range_set
end
%

est_info_proj.proj_name = strcat('XGES',sprintf( '%04d', proj_num  ));

%% 1. create folder [done]

est_info_proj.proj_path = './proj/';
mkdir(est_info_proj.proj_path,est_info_proj.proj_name);
est_info_proj.proj_path = strcat(est_info_proj.proj_path,est_info_proj.proj_name,'/');
est_info_proj.model.filename = generate_model_filename(est_info_proj);


%% 2. creat info file .mat  and save the project info into the excel and mat[done]
% the summerized info are saved in InSilicoExperimentsList.xlsx
% the detailed info are saved in MonolixProjectInfo.mat

generate_project_info_save(exp_records_filename, est_info_proj, proj_num); % to be fixed!!! est_info_proj.est.para_range_set


%% define get_latest_project_num
function project_num = get_latest_project_num(exp_records_filename)
%make sure the file .mat exists before running

MonolixListTable = readtable(exp_records_filename,'Sheet','MonolixProjects');

if nargin<2
    project_num = max(MonolixListTable.ProjectNum);
end
end


