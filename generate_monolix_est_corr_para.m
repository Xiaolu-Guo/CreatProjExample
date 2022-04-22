function [corr_parameters, correlation_def] = generate_monolix_est_corr_para(est_info_proj)

% generate correlation parameters for momolix estimation

corr_parameters = cell.empty;

correlation_def = 'correlation = {level=id,';


% core module parameters are correlated;

for ii = 1:length(est_info_proj.model.est_para_core)
    for jj = (ii+1):length(est_info_proj.model.est_para_core)
        corr_parameters (end+1) = {strcat('corr_',est_info_proj.model.est_para_core{ii},'_',est_info_proj.model.est_para_core{jj})};
        correlation_def = strcat(correlation_def, ' r(',est_info_proj.model.est_para_core{ii},',',...
        est_info_proj.model.est_para_core{jj},')=',corr_parameters (end),',');
    end
    for jj = 1:length(est_info_proj.model.est_para_receptor)
        corr_parameters (end+1) = {strcat('corr_',est_info_proj.model.est_para_core{ii},'_',est_info_proj.model.est_para_receptor{jj})};
        correlation_def = strcat(correlation_def, ' r(',est_info_proj.model.est_para_core{ii},',',...
        est_info_proj.model.est_para_receptor{jj},')=',corr_parameters (end),',');
    end
end

% receptor module paraemters are correlated

for ii = 1:length(est_info_proj.model.est_para_receptor)
    for jj = (ii+1):length(est_info_proj.model.est_para_receptor)
        corr_parameters (end+1) = {strcat('corr_',est_info_proj.model.est_para_receptor{ii},'_',est_info_proj.model.est_para_receptor{jj})};
        correlation_def = strcat(correlation_def, ' r(',est_info_proj.model.est_para_receptor{ii},',',...
            est_info_proj.model.est_para_receptor{jj},')=',corr_parameters (end),',');
    end
end

correlation_def{1,1}(end) = '}';

corr_parameters = corr_parameters';
