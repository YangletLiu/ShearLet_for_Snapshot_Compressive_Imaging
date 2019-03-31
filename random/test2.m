clear all
load("kobe32_cacti.mat")

f = 8;
n = 16;
x = orig(1:n,1:n,1:f);
M = mask(1:n,1:n,1:f);
captured = meas(1:n,1:n,1);
x = x(:);
M = M(:);
captured = captured(:);

N = n*n;
NN = N*f;
cal_num = 5; % 1 to NN
% A = zeros(N,f*N);
A = zeros(NN,cal_num);
for i = 1:f
    for j = 1:cal_num
        A((i-1)*N+j,j) = M((i-1)*N+j);
    end
end
M(M==0)=-1;

L2 = 10; 

% estimated_theta = [];
estimated_theta = zeros(1,cal_num);
for ite =1:L2
    L1 = 1000;
    Phi = zeros(L1,NN);
    y = zeros(L1,1);
    for j=1:L1
        order = randperm(N); 
        % 这里取正负是考虑到由mask中的元素确定的正负是确定的，否则L行中某列上只要非零就都相同
        ps = order(1:N/2);
        ns = order(1+N/2:N);
        
        y(j) = y(j) + sum(captured(ps));
        y(j) = y(j) - sum(captured(ns));
        
        Phi(j,:) = Phi(j,:) + extract_M(ps,N,M,f);
        Phi(j,:) = Phi(j,:) - extract_M(ns,N,M,f);
    end
    
    
%     order = randperm(N*f*L1);
%     nonzero_num = N*f*L1;
%     positive = order(1:nonzero_num/2);
%     negtive = order(nonzero_num/2+1:nonzero_num);
%     Phi(positive) = 1;
%     Phi(negtive) = -1; 
        
    
    
    bias = norm(y - Phi*x);
    
    meass = mean(Phi(:)) % 均值
    var = sum((Phi(:)-meass).*(Phi(:)-meass))/(L1*N*f) % 方差
    
    u = Phi*x;
    v = Phi*A;
    
    % estimated_theta = [estimated_theta;(u'*v)/L1]; % .'的问题
    estimated_theta = estimated_theta + (u'*v)/L1;
end
% sort(estimated_theta);
% if mod(L2,2)==0
%     estimated_theta = (estimated_theta(L2/2,:)+estimated_theta(L2/2+1,:))/2;
% else
%     estimated_theta = estimated_theta(ceil(L2/2,:));
% end

estimated_theta = estimated_theta/L2;

real_theta = A'*x; % the same as captured when f=8
estimated_theta = estimated_theta.';

function vec = extract_M(idx,N,M,f)
    vec = zeros(1,N*f);
    for ite =1:f
        vec(N*(ite-1)+idx) = M(N*(ite-1)+idx);
    end
end