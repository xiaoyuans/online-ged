function [w,G,er] = subONR1(A,y,alpha,beta,lambda1,lambda2)

%%%%%找出收敛的迭代次数

% 
% A     --- The input data
% y     --- The target value
% alpha,beta,lambda1,lambda2     --- The required hyperparameters
G=[];%保存每次迭代的w结果，观察它在多少次迭代时收敛
er=[];
[T,d] = size(A);z = zeros(d,1);
n = zeros(d,1);w = zeros(d,1);
epochs = 1;
ww=ones(d,1);
errr=1;%迭代停止条件
while (errr > 0.0019)
    errr = norm(ww-w);
    ww = w;
    for i = 1:T
        xt = A(i,:);yt = y(i);
        I = find(xt~=0);
        for j = 1:length(I)
            a = I(j);
            if abs(z(a)) <= lambda1
                w(a,1) = 0;
            else
                w(a,1) = -1/((beta + sqrt(n(a)))/alpha + lambda2)*(z(a) - sign(z(a))*lambda1);
            end   
        end
        % update g, n, z
%         sg = sigmoid(xt*w);
        for j = 1:length(I)
            a = I(j);
%             g = (sg-yt)*sg*(1-sg)*xt(a); % changing according to different problem
            g = (xt*w-yt)*xt(a);
            sigma = (sqrt(n(a) + g*g) -sqrt(n(a)))/alpha;
            z(a) = z(a)+g-sigma*w(a);
            n(a) = n(a)+g*g;
        end
    end
    disp(epochs);
    epochs = epochs+1; 
    G=[G,w];
    %disp(errr);
    er=[er,errr];
end
end

function sigm = sigmoid(x)
  
    sigm = 1 ./ (1 + exp(-x));
end