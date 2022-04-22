function  filename = generate_model_filename(est_info_proj)

filename = '';

for ii = 1:length(est_info_proj.model.est_para)
    
    if isempty(est_info_proj.est.para_range_set{ii})
        filename = strcat(filename,est_info_proj.model.est_para{ii},'_');
    else
        filename = strcat(filename,est_info_proj.model.est_para{ii},...
            num2str(est_info_proj.est.para_range_set{ii}(1)),'to',...
            num2str(est_info_proj.est.para_range_set{ii}(2)),'_');
    end
    
end

filename = filename(1:end-1);