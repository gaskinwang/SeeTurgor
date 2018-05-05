function Path4Divide=relativePath(Path4AllCell,selection)
Path4Divide=zeros(size(Path4AllCell));
for ind=1:length(selection)
    Path4Divide(Path4AllCell==selection(ind))=ind;
end
end