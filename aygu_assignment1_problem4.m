clear;
clc;
N = 500;
nreplic = 1000;

f1 = calculate(5, N, nreplic);
f2 = calculate(10, N, nreplic);
f3 = calculate(20, N, nreplic);

function f = calculate(T, N, nreplic)
    beta_hat = zeros(nreplic,1);
    sigma_beta1 =  zeros(nreplic,1);
    sigma_beta2 =  zeros(nreplic,1);
     
    for replic = 1:1:nreplic; 
    x = randn(T,N);
    sigma = abs(x);
    e = sigma.*randn(T,N);
    y = x + e;
    
    ybar = repmat(mean(y),T,1);
    xbar = repmat(mean(x),T,1);
    
    ytrema = y - ybar;
    xtrema = x - xbar;
    
    if T==5 
        ytrema1 = ytrema(1,:);
        ytrema2 = ytrema(2,:);
        ytrema3 = ytrema(3,:);
        ytrema4 = ytrema(4,:);
        ytrema5 = ytrema(5,:);
    
        xtrema1 = xtrema(1,:);
        xtrema2 = xtrema(2,:);
        xtrema3 = xtrema(3,:);
        xtrema4 = xtrema(4,:);
        xtrema5 = xtrema(5,:);
        
        ytremaytrema = [ytrema1, ytrema2, ytrema3, ytrema4, ytrema5];
        xtremaxtrema = [xtrema1, xtrema2, xtrema3, xtrema4, xtrema5];
    elseif T==10  
        ytrema1 = ytrema(1,:);
        ytrema2 = ytrema(2,:);
        ytrema3 = ytrema(3,:);
        ytrema4 = ytrema(4,:);
        ytrema5 = ytrema(5,:);
        ytrema6 = ytrema(6,:);
        ytrema7 = ytrema(7,:);
        ytrema8 = ytrema(8,:);
        ytrema9 = ytrema(9,:);
        ytrema10 = ytrema(10,:);
    
        xtrema1 = xtrema(1,:);
        xtrema2 = xtrema(2,:);
        xtrema3 = xtrema(3,:);
        xtrema4 = xtrema(4,:);
        xtrema5 = xtrema(5,:);
        xtrema6 = xtrema(6,:);
        xtrema7 = xtrema(7,:);
        xtrema8 = xtrema(8,:);
        xtrema9 = xtrema(9,:);
        xtrema10 = xtrema(10,:);
        
        ytremaytrema = [ytrema1, ytrema2, ytrema3, ytrema4, ytrema5, ytrema6, ytrema7, ytrema8, ytrema9, ytrema10];
        xtremaxtrema = [xtrema1, xtrema2, xtrema3, xtrema4, xtrema5, xtrema6, xtrema7, xtrema8, xtrema9, xtrema10];
     else 
        ytrema1 = ytrema(1,:);
        ytrema2 = ytrema(2,:);
        ytrema3 = ytrema(3,:);
        ytrema4 = ytrema(4,:);
        ytrema5 = ytrema(5,:);
        ytrema6 = ytrema(6,:);
        ytrema7 = ytrema(7,:);
        ytrema8 = ytrema(8,:);
        ytrema9 = ytrema(9,:);
        ytrema10 = ytrema(10,:);
        ytrema11 = ytrema(11,:);
        ytrema12 = ytrema(12,:);
        ytrema13 = ytrema(13,:);
        ytrema14 = ytrema(14,:);
        ytrema15 = ytrema(15,:);
        ytrema16 = ytrema(16,:);
        ytrema17 = ytrema(17,:);
        ytrema18 = ytrema(18,:);
        ytrema19 = ytrema(19,:);
        ytrema20 = ytrema(20,:);
    
        xtrema1 = xtrema(1,:);
        xtrema2 = xtrema(2,:);
        xtrema3 = xtrema(3,:);
        xtrema4 = xtrema(4,:);
        xtrema5 = xtrema(5,:);
        xtrema6 = xtrema(6,:);
        xtrema7 = xtrema(7,:);
        xtrema8 = xtrema(8,:);
        xtrema9 = xtrema(9,:);
        xtrema10 = xtrema(10,:);
        xtrema11 = xtrema(11,:);
        xtrema12 = xtrema(12,:);
        xtrema13 = xtrema(13,:);
        xtrema14 = xtrema(14,:);
        xtrema15 = xtrema(15,:);
        xtrema16 = xtrema(16,:);
        xtrema17 = xtrema(17,:);
        xtrema18 = xtrema(18,:);
        xtrema19 = xtrema(19,:);
        xtrema20 = xtrema(20,:);
        
        ytremaytrema = [ytrema1, ytrema2, ytrema3, ytrema4, ytrema5, ytrema6, ytrema7, ytrema8, ytrema9, ytrema10 ...
            ytrema11, ytrema12, ytrema13, ytrema14, ytrema15, ytrema16, ytrema17, ytrema18, ytrema19, ytrema20];
        xtremaxtrema = [xtrema1, xtrema2, xtrema3, xtrema4, xtrema5, xtrema6, xtrema7, xtrema8, xtrema9, xtrema10 ...
            xtrema11, xtrema12, xtrema13, xtrema14, xtrema15, xtrema16, xtrema17, xtrema18, xtrema19, xtrema20];   
        end 
    
    yy = ytremaytrema';
    xx = xtremaxtrema';
   
    beta_hat(replic) = yy'/xx';  
    
    e_hat = ytrema - xtrema*beta_hat(replic); 
                                     
    sigma_beta1(replic) = sqrt((xtremaxtrema*xx)^(-2)*sum(sum(xtrema.*e_hat).^2));
    sigma_beta2(replic) = sqrt((xtremaxtrema*xx)^(-2)*sum(sum((xtrema.^2).*(e_hat.^2))));
    end

    f = [std(beta_hat) mean(sigma_beta1) mean(sigma_beta2) std(sigma_beta1), std(sigma_beta2)...
    sqrt((mean(sigma_beta1)-std(beta_hat))^2 +std(sigma_beta1)^2), sqrt((mean(sigma_beta2)-std(beta_hat))^2 +std(sigma_beta2)^2)]
end
    