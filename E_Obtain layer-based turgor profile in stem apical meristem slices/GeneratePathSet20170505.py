import numpy as np
import scipy.io
Path = scipy.io.loadmat('prepare.mat')['Path'].astype(int)
Boundary = np.arange(1,14)#input the number of L1 cells (boundary cells) plus 1
Levals = []
Levals.append(Boundary.tolist())#第0层
known = Boundary.tolist()
for la in range(1,7):
    temp = []
    for cellnum in np.arange(Path.max()) + 1:
        if cellnum in known:
            pass
        else:
            for pat in Path:
                pat_ = pat.tolist()
                if (cellnum in pat_) and (pat_[pat_.index(cellnum) - 1] in known):
                    temp.append(cellnum)
                    break

    known.extend(temp)
    Levals.append(temp)
    print('debug, Leval',la,':', temp)

remove_list = np.ones(Path.shape[0]) == 0
for path_num,pat in enumerate(Path):
    for ind,pat_cell_num in enumerate(pat):
        if pat_cell_num in Levals[ind]:
            pass
        else:
            remove_list[path_num] = True
            break
remained_path = Path[~ remove_list]
print('all the correct path: \n', remained_path)
scipy.io.savemat('Leval.mat', {('l'+str(ind)):np.array(lav) for ind,lav in enumerate(Levals)})
import xlwings as xw
book = xw.Book()
book.sheets.active.range('A1').value =  np.array(remained_path)
book.save('all the correct path2.xlsx')
