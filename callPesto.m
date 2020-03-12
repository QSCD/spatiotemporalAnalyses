function parameters = callPesto(names,mins,maxs,method,optimizer,numberMS,nrs,sampling,int_var)
% parameters
parameters.name = names;
parameters.min = mins;
parameters.max = maxs;
parameters.number = length(parameters.name);
parameters.objFkt = method;
parameters.dataSize = nrs;
if exist('int_var', 'var')
    parameters.int_var = int_var;
else
    parameters.int_var = [];
end

% Log-likelihood function
objectiveFunction = method;

%options
optionsMultistart = PestoOptions();
optionsMultistart.n_starts = numberMS;
optionsMultistart.obj_type = 'negative log-posterior';
optionsMultistart.objOutNumber = 1;
optionsMultistart.localOptimizer = optimizer;
optionsMultistart.localOptimizerOptions.maxeval = 1000*parameters.number;
optionsMultistart.localOptimizerOptions = optimset(...
    'Algorithm', 'interior-point',...
    'GradObj', 'off',...
    'Display', 'iter', ... 'Hessian', 'on', ... uncomment this to use the Hessian for optimization 
    'MaxIter', 1000,...
    'TolFun', 1e-14,...
        'TolX', 1e-14,...
    'MaxFunEvals', 1000*parameters.number);
optionsMultistart.localOptimizerOptions.maxeval = 1000*parameters.number;
optionsMultistart.localOptimizerOptions.InitialStepSize = 0.1;
optionsMultistart.localOptimizerOptions.meigoOpts.maxeval = 1000*parameters.number;
optionsMultistart.localOptimizerOptions.meigoOpts.local.solver='misqp';
optionsMultistart.localOptimizerOptions.meigoOpts.local.solver=0;

% Optimization
% addpath D:\PhD\scripts\PESTO-master
parameters = getMultiStarts(parameters, objectiveFunction, optionsMultistart);
% rmpath D:\PhD\scripts\PESTO-master
%Sampling
if ~exist('sampling', 'var')
    sampling =true;
end
if sampling
optS = PestoOptions();
optS.MCMC=PestoSamplingOptions();
optS.MCMC.PT = PTOptions();
optS.MCMC.PT.nTemps=10;
optS.MCMC.PT.maxT = 100;
optS.MCMC.theta0 = (repmat(parameters.min,1,optS.MCMC.PT.nTemps)' + ...
    repmat((parameters.max-parameters.min),1,optS.MCMC.PT.nTemps)'.*rand(optS.MCMC.PT.nTemps,parameters.number))';
optS.MCMC.sigma0 = 1e5 * diag(ones(1,parameters.number));
optS.MCMC.nIterations=1000;
parameters=getParameterSamples(parameters,@(x)-parameters.objFkt(x),optS);
end
