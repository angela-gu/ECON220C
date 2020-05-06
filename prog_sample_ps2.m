% Angela Gu
% Econ 220C
% Spring 2020
% Problem Set 2

%%

clearvars;
N = 100;
nreplic = 1000;

f1 = calculate(6, N, nreplic);
f2 = calculate(3, N, nreplic);
f3 = calculate(9, N, nreplic);
 
function f = calculate(T, N, nreplic)

rho0 = 0.5;

% keep the bias of each estimator
bias_pols=zeros(10,1);
bias_fe=zeros(10,1);
bias_fd=zeros(10,1);
bias_ah2=zeros(10,1);  

% keep the se of each estimator
se_pols = zeros(10,1);
se_fe = zeros(10,1);
se_fd = zeros(10,1);
se_ah2 = zeros(10,1);

% keep the rmse of each estimator
rmse_pols = zeros(10,1);
rmse_fe = zeros(10,1);
rmse_fd = zeros(10,1);
rmse_ah2 = zeros(10,1);

%%

rho = (0.1:0.1:1)'; %the values of rho considered

for irho = 1:1:10;  % loop over each value of rho's

  a = [1 -rho(irho)];
  b = 1;  % configure a and b to speed up the data generating
 
  rho_pols = zeros(nreplic,1);
  rho_fe = zeros(nreplic,1);  % keep the fixed effects estimator
  rho_fd = zeros(nreplic,1);
  rho_ah2 = zeros(nreplic,1);
  
  t_pols = zeros(nreplic,1);
  t_fe = zeros(nreplic,1); % keep the t statistic based on the fe estimator
  t_fd = zeros(nreplic,1);
  t_ah2 = zeros(nreplic,1);
  
  randn('state',pi);
% initialize the random number generator

   for replic = 1:1:nreplic; 
    
		alpha = randn(1,N);  
		e = randn(1,N);
		y0 = rho0*alpha+e; 
		
	
		temp = [y0; randn(T,N)+alpha(ones(T,1),:)];
		data  =  filter(b,a, temp);   
		
		x = data(1:end-1,:);
		y = data(2:end,:);
          
		% data in wide format
          
		clear temp data;
        
        %%%%%%%%%%%%% Pooled OLS estimator %%%%%%%%%%%%%%%%%
		rho_pols(replic) = x(:)\y(:);
        
        err_pols = y(:)-x(:)*rho_pols(replic); % regression error
            
        avar_pols = 0;
        for ii=1:1:N;   
         index = ((ii-1)*T+1: ii*T)';
         avar_pols = avar_pols + x(index)'*err_pols(index)*err_pols(index)'*x(index);
        end;
        
        avar_pols = inv(x(:)'*x(:))*avar_pols*inv(x(:)'*x(:));
        
        t_pols(replic) = (rho_pols(replic)-rho(irho))/sqrt(avar_pols);
         
    	%%%%%%%%%%%%% FE estimator %%%%%%%%%%%%%%%%%
		x_fe = x-repmat(mean(x),T,1);
		y_fe = y-repmat(mean(y),T,1);
		rho_fe(replic) = x_fe(:)\y_fe(:);
        
        err_fe = y_fe(:)-x_fe(:)*rho_fe(replic); % regression error
            
        avar_fe = 0;
        for ii=1:1:N;   
         index = ((ii-1)*T+1: ii*T)';
         avar_fe = avar_fe + x_fe(index)'*err_fe(index)*err_fe(index)'*x_fe(index);
        end;
        
        avar_fe = inv(x_fe(:)'*x_fe(:))*avar_fe*inv(x_fe(:)'*x_fe(:));
        
        t_fe(replic) = (rho_fe(replic)-rho(irho))/sqrt(avar_fe);
        
        %%%%%%%%%%%%% FD estimator %%%%%%%%%%%%%%%%%
        x_fd = x(2:end,:)-x(1:end-1,:);
		y_fd = y(2:end,:)-y(1:end-1,:);

        rho_fd(replic) = x_fd(:)\y_fd(:);
        
        err_fd = y_fd(:)-x_fd(:)*rho_fd(replic); % regression error
            
        avar_fd = 0;
        for ii=1:1:N/2;
         index = ((ii-1)*T+1: ii*T)';
         avar_fd = avar_fd + x_fd(index)'*err_fd(index)*err_fd(index)'*x_fd(index);
        end;
        
        avar_fd = inv(x_fd(:)'*x_fd(:))*avar_fd*inv(x_fd(:)'*x_fd(:));
        
        t_fd(replic) = (rho_fd(replic)-rho(irho))/sqrt(avar_fd);
		
		%%%%%%%%%%%%% AH estimator %%%%%%%%%%%%%%%%%
        x_ah = x(2:end,:)-x(1:end-1,:);
		y_ah = y(2:end,:)-y(1:end-1,:);
        
		z = reshape(x(1:end-1,:),[],1);

        rho_ah(replic) = (z'*y_ah(:))/(z'*x_ah(:));
        
        err_ah = y_ah(:)-x_ah(:)*rho_ah(replic); % regression error
            
        avar_ah = 0;
        for ii=1:1:N/2;
         index = ((ii-1)*T+1: ii*T)';
         avar_ah = avar_ah + x_ah(index)'*err_ah(index)*err_ah(index)'*x_ah(index);
        end;
        
        avar_ah = inv(x_ah(:)'*x_ah(:))*avar_ah*inv(x_ah(:)'*x_ah(:));
        
        t_ah(replic) = (rho_ah(replic)-rho(irho))/sqrt(avar_ah);
                
    end;

bias_pols(irho) = mean(rho_pols)-rho(irho);
bias_fe(irho)  =  mean(rho_fe)-rho(irho);
bias_fd(irho)  =  mean(rho_fd)-rho(irho);
bias_ah(irho)  =  mean(rho_ah)-rho(irho);

se_pols(irho) = std(rho_pols);
se_fe(irho)  =  std(rho_fe);
se_fd(irho)  =  std(rho_fd);
se_ah(irho)  =  std(rho_ah);

rmse_pols(irho) = sqrt(se_pols(irho)^2+bias_pols(irho)^2);
rmse_fe(irho)  =  sqrt(se_fe(irho)^2+bias_fe(irho)^2);
rmse_fd(irho)  =  sqrt(se_fd(irho)^2+bias_fd(irho)^2);
rmse_ah(irho)  =  sqrt(se_ah(irho)^2+bias_ah(irho)^2);

	
	if rho(irho) == 0.7;
        figure;
		[freq, bins]= hist(t_pols);
        bar(bins, freq/sum(freq));
        hold on;
        x=(-2.5:0.1:2.5)';
        histfit(t_pols,length(bins),'normal');
		title({'Histogram of the t_{POLS} statistic'; ['\rho = ' num2str(0.7) ', N = ' num2str(N) ', T = ' num2str(T)]}); 
        orient landscape;
        print('-depsc2', ['histogram' '_N_' num2str(N) '_T_' num2str(T) '.eps']);
        
		figure;
		[freq, bins]= hist(t_fe);
        bar(bins, freq/sum(freq));
        hold on;
        x=(-2.5:0.1:2.5)';
        histfit(t_fe,length(bins),'normal');
		title({'Histogram of the t_{FE} statistic'; ['\rho = ' num2str(0.7) ', N = ' num2str(N) ', T = ' num2str(T)]});
        orient landscape;
        print('-depsc2', ['histogram' '_N_' num2str(N) '_T_' num2str(T) '.eps']);    
        
        figure;
		[freq, bins]= hist(t_fd);
        bar(bins, freq/sum(freq));
        hold on;
        x=(-2.5:0.1:2.5)';
        histfit(t_fd,length(bins),'normal');
		title({'Histogram of the t_{FD} statistic'; ['\rho = ' num2str(0.7) ', N = ' num2str(N) ', T = ' num2str(T)]});
        orient landscape;
        print('-depsc2', ['histogram' '_N_' num2str(N) '_T_' num2str(T) '.eps']);  
        
        figure;
		[freq, bins]= hist(t_ah);
        bar(bins, freq/sum(freq));
        hold on;
        x=(-2.5:0.1:2.5)';
        histfit(t_ah,length(bins),'normal');
		title({'Histogram of the t_{AH} statistic'; ['\rho = ' num2str(0.7) ', N = ' num2str(N) ', T = ' num2str(T)]});
        orient landscape;
        print('-depsc2', ['histogram' '_N_' num2str(N) '_T_' num2str(T) '.eps']);  
    end;
     

end;

figure;
H1 = plot(rho, bias_pols,...
     rho, bias_fe, 'k+:',...
     rho, bias_fd,  'bo-',...
     rho, bias_ah,  'rs-.');
H2= legend('pols', 'fe','fd','ah');
title(['Bias of Different Estimators,' ' N = ' num2str(N) ', T = ' num2str(T)]);
xlabel ('\rho'); 
ylabel ('bias');
set(H1, 'linewidth', 2,'markersize', 4);
set(H2, 'fontsize', 12)
orient landscape;
print('-depsc2', ['bias_se_rmse' '_N_' num2str(N) '_T_' num2str(T) '.eps'])

figure;
H1 = plot(rho, bias_pols, ...
          rho, se_pols, ...
          rho, rmse_pols);
H2= legend('bias', 'se', 'rmse');
title(['Bias, SE, RMSE of Pooled OLS Estimator,' ' N = ' num2str(N) ', T = ' num2str(T)]);
xlabel ('\rho'); 
ylabel ('bias');
set(H1, 'linewidth', 2,'markersize', 4);
set(H2, 'fontsize', 12)
orient landscape;
print('-depsc2', ['bias_se_rmse' '_N_' num2str(N) '_T_' num2str(T) '.eps'])

figure;
H1 = plot(rho, bias_fe, 'k+:', ...
          rho, se_fe, ...
          rho, rmse_fe);
H2= legend('bias', 'se', 'rmse');
title(['Bias, SE, RMSE of FE Estimator,' ' N = ' num2str(N) ', T = ' num2str(T)]);
xlabel ('\rho'); 
ylabel ('bias');
set(H1, 'linewidth', 2,'markersize', 4);
set(H2, 'fontsize', 12)
orient landscape;
print('-depsc2', ['bias_se_rmse' '_N_' num2str(N) '_T_' num2str(T) '.eps'])

figure;
H1 = plot(rho, bias_fd,  'bo-', ...
          rho, se_fd, ...
          rho, rmse_fd);
H2= legend('bias', 'se', 'rmse');
title(['Bias, SE, RMSE of FD Estimator,' ' N = ' num2str(N) ', T = ' num2str(T)]);
xlabel ('\rho'); 
ylabel ('bias');
set(H1, 'linewidth', 2,'markersize', 4);
set(H2, 'fontsize', 12)
orient landscape;
print('-depsc2', ['bias_se_rmse' '_N_' num2str(N) '_T_' num2str(T) '.eps'])

figure;
H1 = plot(rho, bias_ah,  'rs-.', ...
          rho, se_ah, 'bo-', ...
          rho, rmse_ah);
H2= legend('bias', 'se', 'rmse');
title(['Bias, SE, RMSE of AH Estimator,' ' N = ' num2str(N) ', T = ' num2str(T)]);
xlabel ('\rho'); 
ylabel ('bias');
set(H1, 'linewidth', 2,'markersize', 4);
set(H2, 'fontsize', 12)
orient landscape;
print('-depsc2', ['bias_se_rmse' '_N_' num2str(N) '_T_' num2str(T) '.eps'])

f = [];
        
end
