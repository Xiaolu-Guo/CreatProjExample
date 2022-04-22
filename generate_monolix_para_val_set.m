function parameter_val_def = generate_monolix_para_val_set(est_info_proj)

% generate individual parameters def and estimation method for momolix
% project

parameter_val_def = cell.empty;
[corr_parameters, ~] = generate_monolix_est_corr_para(est_info_proj);

for ii = 1:length(corr_parameters)
    
    parameter_val_def(end+1) = {strcat(corr_parameters{ii},' = {value=0, method=MLE}')};
    
end

parameter_val_def = parameter_val_def';

opts1 = detectImportOptions('parameter_setting.xlsx','Sheet','param_setting');
for jj = 1: length(opts1.VariableNames)
    opts1 = setvartype(opts1, opts1.VariableNames{jj}, 'char');
end
parameter_setting = readtable('parameter_setting.xlsx',opts1);

opts2 = detectImportOptions('parameter_setting.xlsx','Sheet','para_default');
for jj = 1: length(opts2.VariableNames)
    opts2 = setvartype(opts2, opts2.VariableNames{jj}, 'char');
end
default_parameter_setting = readtable('parameter_setting.xlsx',opts2);
for ii = 1:length(est_info_proj.model.est_para)
    
    index_para = strcmp(est_info_proj.model.est_para{ii},parameter_setting.parameter);
    index_para_default = strcmp(est_info_proj.model.est_para{ii},default_parameter_setting.parameter);
    
    if sum(index_para)
        % default parameter setting
        
        index_write = index_para;
        parameter_setting_write = parameter_setting;
        
    else
        
        if ~sum(index_para_default)
            error('wrong parameter name!')
        end
        
        index_write = index_para_default;
        parameter_setting_write = default_parameter_setting;
    end
    
    field_variable1 = est_info_proj.est;
    field_variable2 = parameter_setting_write;
    index_field_variable1 = ii;
    index_field_variable2 = index_write;
    
    % set the mean_method and mean_intial value
    
    field_name = 'mean_method';
    
    est_mean_method = get_field_value(field_name, ...
        field_variable1,field_variable2,index_field_variable1,index_field_variable2);
    
    field_name = 'mean_initial';
    default_value = parameter_setting_write.Value{index_write};
    
    est_mean_initial = get_field_value(field_name, ...
        field_variable1,field_variable2,index_field_variable1,index_field_variable2,default_value);
    
    parameter_val_def(end+1) = {strcat(est_info_proj.model.est_para{ii},'_pop = {value=',est_mean_initial,', method=',est_mean_method,'}')};
    
    % set the std_method and std_intial value
    field_name = 'std_method';
    
    est_std_method = get_field_value(field_name, ...
        field_variable1,field_variable2,index_field_variable1,index_field_variable2);
    
    field_name = 'std_initial';

    est_std_initial = get_field_value(field_name, ...
        field_variable1,field_variable2,index_field_variable1,index_field_variable2);
    
    parameter_val_def(end+1) = {strcat('omega_',est_info_proj.model.est_para{ii},...
        ' = {value=',est_std_initial,', method=',est_std_method,'}')};
    
end

end