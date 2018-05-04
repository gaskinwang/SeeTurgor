function P = imagecut2(imfn,m,n)
id = find(imfn=='.');
ffn = imfn(1:id-1);      % path and filename
ext = imfn(id:end);      % filename extension
p = imread(imfn);
[pm,pn,pp] = size(p);
cm = ceil(pm/m);
cn = ceil(pn/n);
P = cell(m,n);
for k = 1:m
    fm = (k-1)*cm+1;
    tm = fm+cm-1;
    for h = 1:n
        fn = (h-1)*cn+1;
        tn = fn+cn-1;
        if k == m & h == n
            P{k,h} = p(fm:end,fn:end,1:pp);
        elseif k == m
            P{k,h} = p(fm:end,fn:tn,1:pp);
        elseif h == m
            P{k,h} = p(fm:tm,fn:end,1:pp);
        else
            P{k,h} = p(fm:tm,fn:tn,1:pp);
        end
        nfn = [ffn num2str(k) num2str(h) ext];
        imwrite(P{k,h},nfn);   % save nfn
    end
end