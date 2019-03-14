% 拆开对k个二维图片分别操作，投影后的向量做内积，求和求期望
function theta = estimate_product(L,N,frames,Phi,psi,theta,y)    
    for k = 1:frames
        x = Phi(:,:,k)*(psi).';
        theta((k-1)*N+1:k*N) = theta((k-1)*N+1:k*N) + (y'*x).'/sqrt(L);
    end
end