function parameters = callPesto(names,mins,maxs,method,optimizer,numberMS,nrs,sampling)
% prepares all needed options to start a parameter inference with PESTO

% parameters
parameters.name = names;
parameters.min = mins;
parameters.max = maxs;
parameters.number = length(parameters.name);
parameters.objFkt = method;
parameters.dataSize = nrs;

% Log-likelihood function
objectiveFunction = method;

% multistart options
optionsMultistart = PestoOptions();
optionsMultistart.n_starts = numberMS;
optionsMultistart.obj_type = 'negative log-posterior';
optionsMultistart.objOutNumber = 1;
optionsMultistart.localOptimizer = optimizer;
optionsMultistart.localOptimizerOptions.maxeval = 1000*parameters.number;
optionsMultistart.localOptimizerOptions = optimset(...
    'Algorithm', 'interior-point',...
    'GradObj', 'off',...
    'Display', 'iter', ...
    'MaxIter', 1000,...
    'TolFun', 1e-14,...
    'TolX', 1e-14,...
    'MaxFunEvals', 1000*parameters.number);

% Optimization
% run optimization
parameters = getMultiStarts(parameters, objectiveFunction, optionsMultistart);

%Sampling options
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
    % run sampling
    parameters=getParameterSamples(parameters,@(x)-parameters.objFkt(x),optS);
end
