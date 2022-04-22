function [ind_parameters,ind_parameter_def ]= generate_monolix_est_ind_para(est_info_proj)

% generate individual parameters for momolix estimation

ind_parameters = cell.empty;
ind_parameter_def = cell(2,1);

para_index=1;

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
    
    ind_parameters(end+1) = {strcat(est_info_proj.model.est_para{ii},'_pop')};
    ind_parameters(end+1) = {strcat('omega_',est_info_proj.model.est_para{ii})};
    
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
    
    field_name = 'distribution_type';
    
    
    distribution_type = get_field_value(field_name, ...
        field_variable1,field_variable2,index_field_variable1,index_field_variable2);
    
    if strcmp(distribution_type, 'logitNormal')
        
        
        % set the min_val for the logitNormal distribution
        field_name = 'min_val';
        
        
        min_val = get_field_value(field_name, ...
            field_variable1,field_variable2,index_field_variable1,index_field_variable2);
        
        if isempty(min_val)
            min_val = str2double(parameter_setting_write.Value{index_write})*0.1;
        else
            min_val = str2double(min_val);
        end
        
        
        % set the min_val for the logitNormal distribution
        field_name = 'max_val';
 
        
        max_val = get_field_value(field_name, ...
            field_variable1,field_variable2,index_field_variable1,index_field_variable2);
        
        if isempty(max_val)
            max_val = str2double(parameter_setting_write.Value{index_write})*10;
        else
            max_val = str2double(max_val);
        end
        
    end
    
    
    switch distribution_type
        case 'logNormal'
            
            %NFkB_cyto_init = {distribution=logitNormal, min=0.04, max=0.16, typical=NFkB_cyto_init_pop, sd=omega_NFkB_cyto_init}
            ind_parameter_def(para_index) = {strcat(est_info_proj.model.est_para{ii}, ' = {distribution=',...
                distribution_type, ', typical= ',est_info_proj.model.est_para{ii},'_pop, sd=omega_',est_info_proj.model.est_para{ii},'}')};
            
        case 'logitNormal'
            
            ind_parameter_def(para_index) = {strcat(est_info_proj.model.est_para{ii}, ' = {distribution=',...
                distribution_type, ', min=',num2str(min_val),', max=',num2str(max_val),...
                ', typical= ',est_info_proj.model.est_para{ii},'_pop, sd=omega_',est_info_proj.model.est_para{ii},'}')};
            
            %shift = {distribution=logNormal, typical=shift_pop, sd=omega_shift}
            
    end
    
    para_index = para_index+1;
    
end

ind_parameters = ind_parameters';

end

% %% to be fixed
% default_parameter_setting = {...
%     'NFkB_cyto_init = {distribution=logitNormal, min=0.04, max=0.16, typical=NFkB_cyto_init_pop, sd=omega_NFkB_cyto_init}';
% 'params100 = {distribution=logitNormal, min=0.01, typical=params100_pop, sd=omega_params100}';
% 'params101 = {distribution=logitNormal, min=0.01, typical=params101_pop, sd=omega_params101}';
% 'params25 = {distribution=logitNormal, min=0.2, max=20, typical=params25_pop, sd=omega_params25}';
% 'params26 = {distribution=logitNormal, min=0.2, max=20, typical=params26_pop, sd=omega_params26}';
% 'params6 = {distribution=logitNormal, min=6e-6, max=0.0006, typical=params6_pop, sd=omega_params6}';
% 'params6n2 = {distribution=logitNormal, min=0.3, max=30, typical=params6n2_pop, sd=omega_params6n2}';
% 'params96 = {distribution=logitNormal, min=0.01, typical=params96_pop, sd=omega_params96}';
% 'params97 = {distribution=logitNormal, min=0.01, typical=params97_pop, sd=omega_params97}';
% 'params98 = {distribution=logitNormal, min=0.005, max=0.5, typical=params98_pop, sd=omega_params98}';
% 'params99 = {distribution=logitNormal, min=0.01, typical=params99_pop, sd=omega_params99}';
% 'shift = {distribution=logNormal, typical=shift_pop, sd=omega_shift}'};
%
% default_parameter_order = {'NFkB_cyto_init'
%     'params100'
% 'params101'
% 'params25'
% 'params26'
% 'params6'
% 'params6n2'
% 'params96'
% 'params97'
% 'params98'
% 'params99';
% 'shift'};
%
% para_set.index=
%
% params1 = 1;
% params2 = 2e-05;
% params3 = 2;
% params4 = 18;
% params5 = 5e-07;
% params6 = 6e-05;
% params6n2 = 2.938;
% params6n3 = 0.1775;
% params6n4 = 14;
% params7 = 0.0577623;
% params8 = 30;
% params8n2 = 1;
% params9 = 0.0225;
% params9n2 = 3.5; % Volume scale: cytoplasmic/nuclear volume
% params10 = 0.6; % nuclear import of NFkB
% params10n2 = params9n2; % Volume scale: cytoplasmic/nuclear volume
% params11 = 0.1575; % nuclear export of IkBa
% params11n2 = 1/params9n2; % Volume scale: nuclear/cytoplasmic volume
% params12 = 0.042; % nuclear export of NFkB
% params12n2 = 1/params9n2; % Volume scale: nuclear/cytoplasmic volume
% params13 = 0; % nuclear import of IkBa-NFkB
% params13n2 = params9n2; % Volume scale: cytoplasmic/nuclear volume
% params14 = 0.828; % nuclear export of IkBa-NFkB
% params14n2 = 1/params9n2; % Volume scale: cytoplasmic/nuclear volume
% params15 = 0.0770164; % degradation of IkBa
% params16 = 0.0770164; % degradation of IkBa (nuc)
% params17 = 200; % IkBa-NFkB association
% params18 = 200; % IkBa-NFkB association (nuc)
% params19 = 0.008; % IkBa-NFkB dissociation
% params20 = 0.008; % IkBa-NFkB dissociation (nuc)
% params21 = 190; % IKK-IkBa-NFkB association
% params22 = 190; % IKK-IkBa association
% params23 = 38; % IKK-IkBa-NFkB dissociation
% params24 = 38; % IKK-IkBa dissociation
% ;params25 = 2; % Phosphorylation/degradation of complexed IkBa
% params26 = 2; % Phosphorylation/degradation of IkBa
% ;params27 = 8.75; % CD14-LPS association
% params27n2 = 0.001; % Scale for external (media) vs. internal (cellular) volumes
% params28 = 0.07; % CD14-LPS dissociation
% params28n2 = 0.001; % Scale for external (media) vs. internal (cellular) volumes
% params29 = 0.00112; % CD14 synthesis
% params30 = 0.000878; % CD14 degradation
% params31 = 5.543; % Assocation of LPS and CD14 in plasma membrane
% params32 = 0.0277; % Disassociation of TLR4LPS in the plamsa membrane
% params33 = 5.543; % Assocation of LPS and CD14 in the endosome
% params34 = 0.0277; % Disassociation of TLR4LPS in the endosome
% params35 = 5.25e-05; % Synthesis rate of TLR4
% params36 = 0.065681; % Induced endocytosis of CD14
% params37 = 0.04; % Recycling of CD14
% params38 = 0.028028; % Constitutive endocytosis of TLR4
% params39 = 0.5; % Recycling of TLR4
% params40 = 0.065681; % Induced endocytosis of activated CD14-TLR4
% params41 = 0.04; % Recycling of CD14-TLR4
% params42 = 0.07; % Degradation of CD14-LPS
% params43 = 0.0653; % Degradation of TLR4
% params44 = 0.012; % Degradation of activated TLR4-LPS
% params45 = 150; % Activation of MyD88
% params45n2 = 3; % Hill coefficient for MyD88 activation
% params45n3 = 0.012448; % EC50 for MyD88 activation
% params46 = 2600; % Deactivation of MyD88
% params47 = 6; % Activation of TRIF
% params48 = 0.2; % Deactivation of TRIF
% params49 = 30; % Activation of TRAF6 by MyD88
% params50 = 0.4; % Activation of TRAF6 by TRIF
% params51 = 0.125; % Deactivation of TRAF6
% params52 = 0.105; % Activation of TAK1 by TRAF6
% params53 = 0.0116; % TNF degradation
% params54 = 8.224e-06; % TNFR synthesis
% params55 = 0.02384; % TNFR degradation
% params56 = 1100; % Capture of TNF
% params56n2 = 0.001; % Scale for external (media) vs. internal (cellular) volumes
% params57 = 0.021; % Release of TNF
% params57n2 = 0.001; % Scale for external (media) vs. internal (cellular) volumes
% params58 = 0.125; % Internalization/degradation of complexed TNFR
% params59 = 34.08; % Association of TRAF2/RIP1 with receptor trimer
% params60 = 0.03812; % Dissociation of TRAF2/RIP1 with receptor trimer
% params61 = 0.125; % Internalization/degradation of complexed TNFR
% params62 = 1.875; % Activation of complexed TNFR
% params63 = 320.3; % Inactivation of complexed TNFR
% params64 = 0.125; % Internalization/degradation of complexed TNFR
% params65 = 1889; % Activation of TAK1 by C1
% params66 = 0.5188; % Inactivation of TAK1
% params67 = 18.79; % Activation of IKK by TAK1
% params67n2 = 2; % Hill coefficient for IKK activation
% params67n3 = 0.001116; % EC50 for mRNA syn
% params68 = 1e-06; % TLR1/2 synthesis
% params69 = 0.0004; % TLR1/2 degradation
% params70 = 1; % Association of CD14 and lipoprotein
% params70n2 = 0.001; % Scale for external (media) vs. internal (cellular) volumes
% params71 = 1.8; % Dissociation of CD14/lipoprotein
% params71n2 = 0.001; % Scale for external (media) vs. internal (cellular) volumes
% params72 = 5.543; % NaN
% params73 = 0.07; % Degradation of CD14-P3CSK
% params74 = 0.02; % NaN
% params75 = 0.001; % Degradation of ligand/receptor
% params76 = 150; % Activation of MyD88
% params76n2 = 3; % Hill coefficient for MyD88 activation
% params76n3 = 0.0032; % EC50 for MyD88 activation
% params77 = 3e-06; % TLR3 synthesis
% params78 = 0.0007; % TLR3 degradation
% params79 = 0.04; % Poly(I:C) internalization
% params79n2 = 0.03; % EC50 for poly(I:C) internalization
% params79n3 = 1; % Hill coefficient for poly(I:C) internalization
% params79n4 = 0.001; % NaN
% params80 = 0.04; % NaN
% params80n2 = 0.001; % Poly(I:C) release
% params81 = 0.5; % NaN
% params82 = 0.025; % NaN
% params83 = 0.0007; % Bound poly(I:C)-TLR3 degradation
% params84 = 20; %  Activation of TRIF by bound TLR3
% params85 = 2e-06; % TLR9 synthesis
% params86 = 0.0004; % TLR9 degradation
% params87 = 0.0004; % TLR9 degradation (N terminus fragment)
% params88 = 0.015; % CpG internalization
% params88n2 = 0.5; % EC50 for CpG internalization
% params88n3 = 1; % Hill coefficient for CpG internalization
% params88n4 = 0.001; % NaN
% params89 = 0.028; % CpG exchange from endosome
% params89n2 = 0.001; % NaN
% params90 = 3; % Ligand-receptor association
% params91 = 0.5; % Ligand-receptor dissociation
% params92 = 3; % Mediated degrdadation of bound TLR9
% params93 = 0.0016; % Bound CpG-TLR9 degradation
% params94 = 200; % Activation of MyD88
% params94n2 = 3; % Hill coefficient for MyD88 activation
% params94n3 = 0.0032; % EC50 for MyD88 activation
% params95 = 0; % degradation of NF-kB (used as proxy for irreversible sequestration)
% params96 = 0.33; % IkBat to IkBat_cas1 transformation rate
% params97 = 0.33; % IkBat_cas1 to IkBat_cas2 transformation rate
% params98 = 0.0577623; % IkBat_cas2 mRNA degradation
% params99 = 0.25; %production rate from  NFkBn to NFkBn_cas1
% params100 = params99; %transformation rate from NFkBn_cas1 to NFkBn_cas2
% params101 = params99; %degradation rate of NFkBn_cas2

