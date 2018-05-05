function BestGen=myga5(GaStrategy)
%% 初始各种运行参数
% 基础信息变量
TribeSize           =GaStrategy.TribeSize;
GenSize             =GaStrategy.GenSize;
AddationImformation =GaStrategy.AddationImformation;
% 核心信息变量，影响进化的关键
DiasterCountDown    =GaStrategy.DiasterCountDown;
HighTribeMixMax   =GaStrategy.HighTribeMixMax;
EvolutionYearMax    =GaStrategy.EvolutionYearMax;
TimeMax             =GaStrategy.TimeMax*60;%时间，以分钟记
% 显示控制变量
MovieOn             =GaStrategy.MovieOn;
MovieClearCountDown =GaStrategy.MovieClearCountDown;%定时清空画图以避免卡机现象

%% 初始化种群
HighTribe  =rand(TribeSize,GenSize);
LowTribe   =rand(TribeSize,GenSize);
GenChange  =rand(TribeSize,GenSize);
GenExchange=rand(TribeSize,GenSize);
MixGen     =zeros(TribeSize*3,GenSize);


%% 初始化运行参数&数据记录系统

tic%时间记录开始
Stage=1;
FinalRun=false;
Logs=cell(2,1);
Logs_mark=ones(2,1);
Logs{1}=zeros(100000,4);%记录代数、时间、fitnessfun、objfun
Logs{1}(1,:)=[0,toc(),NaN,-inf];
Logs{2}=zeros(1000,4);
Logs{2}(1,:)=[0,toc(),NaN,-inf];
CountDown=[DiasterCountDown HighTribeMixMax];
cd=CountDown;
Year=ones(3,1);%时间有三个，低等部落时间，高等部落时间和总时间
generation=1;

mccd=MovieClearCountDown;
if MovieOn;h_fig=figure();hold on;end%初始画面
scrsz = get(0,'ScreenSize');
set(h_fig,'Position',scrsz)%全屏显示
textsize=zeros(2,1);
textsize(1)=min(TribeSize,14);
textsize(2)=min(GenSize,40);
subplot(2,4,1);hold on;  h_fitness(1)=gca;
subplot(2,4,2);hold on;h_objective(1)=gca;
subplot(2,4,3);hold on;  h_fitness(2)=gca;
subplot(2,4,4);hold on;h_objective(2)=gca;
subplot(2,4,5:8);axis([0 100 0 100]);reporters=gca;
h_text=text(reporters,0,50,num2str(LowTribe(1:textsize(1),1:textsize(2)),'%.1f  '));
h_text2=text(reporters,0,120,sprintf('当前是第%d子群，已过时间%d min,还需%d min',...
generation,floor(toc()/60),ceil(TimeMax/60-toc()/60)),'color','red','fontsize',15);
set(reporters,'visible','off')




while true%这一部分是核心，没有放到单独的函数而是写到一块是出于性能考虑
    delete(h_text2);
    h_text2=text(reporters,0,120,sprintf('当前是第%d子群，已过时间%d min,还需%d min',...
generation,floor(toc()/60),ceil(TimeMax/60-toc()/60)),'color','red','fontsize',15);
   %% 低等部落更新
    % 选择
    MixGen(:)=[LowTribe;GenChange;GenExchange];
    ObjectiveValue=objFun(MixGen,AddationImformation);
    FitnessValue=fitFun(ObjectiveValue);
    [~,SortOfFitnessValue]=sort(FitnessValue);
    LowTribe=MixGen(SortOfFitnessValue(end:-1:end-(TribeSize-1)),:);
    % 记录和可视化功能
    if FitnessValue(SortOfFitnessValue(end))>Logs{Stage}(Logs_mark(Stage),4)
        ShowStatus()
        drawnow;
        Logs_mark(Stage)=Logs_mark(Stage)+1;
        Logs{Stage}(Logs_mark(Stage),:)=[Year(Stage),toc(),...
            ObjectiveValue(SortOfFitnessValue(end)),FitnessValue(SortOfFitnessValue(end))];
        cd(1)=CountDown(1);
    elseif Stage==1
        cd(Stage)=cd(Stage)-1;
    end
    if Stage==2
        cd(Stage)=cd(Stage)-1;
    end
    % 变异
    GenChange(:)=LowTribe;
    mark=ceil(rand(TribeSize,2)*GenSize);
    mark=sort(mark,2);
    for aaa=1:TribeSize
        GenChange(aaa,mark(aaa,1):mark(aaa,2))=rand(1,mark(aaa,2)-mark(aaa,1)+1);
    end
    % 交叉互换
    GenExchange(:)=LowTribe;
    ExchangeLength=size(GenExchange,1);
    ExchangSelect=randperm(ExchangeLength);
    mark=ceil(rand(ExchangeLength/2,2)*GenSize);
    mark=sort(mark,2);
    for aaa=1:ExchangeLength/2
        GenExchange([ExchangSelect(aaa),ExchangSelect(aaa+ExchangeLength/2)],mark(aaa,1):mark(aaa,2))=...
            GenExchange([ExchangSelect(aaa+ExchangeLength/2),ExchangSelect(aaa)],mark(aaa,1):mark(aaa,2));
    end
    % 判断是否进行切换
    if cd(Stage)==0;
        switch(Stage)
            case 1%切换到高等部落更新
                Year(1)=1;
                Logs{1}=Logs{1}*0;
                Logs_mark(Stage)=1;
                Logs{1}(1,:)=[0,toc(),NaN,-inf];
                cd(Stage)=CountDown(Stage);
                GenChange(:)=LowTribe;
                LowTribe(:)=HighTribe;
                Stage=2;
            case 2%切换到低等部落更新
                cd(Stage)=CountDown(Stage);
                HighTribe(:)=LowTribe;
                LowTribe=rand(TribeSize,GenSize);
                GenChange(:)=rand(TribeSize,GenSize);
                GenExchange=rand(TribeSize,GenSize);
                Stage=1;
                h_plot=findobj(h_fitness(1),'Color','black');
                delete(h_plot)
                h_plot=findobj(h_objective(1),'Color','black');
                delete(h_plot)
                generation=generation+1;
        end
    end
    %判断是否终止
    Year(Stage)=Year(Stage)+1;
    Year(3)=Year(3)+1;
    if FinalRun;break;end
    JudgeStop();
end

BestGen=LowTribe(1,:);

%% 功能性子函数
    function JudgeStop()
        if toc> TimeMax;FinalRun=true;end
        if Year(3)>=EvolutionYearMax;FinalRun=true;end
        if FinalRun&&Stage==1
            Year(1)=1;
            cd(Stage)=CountDown(Stage);
            GenChange(:)=LowTribe;
            LowTribe(:)=HighTribe;
            Stage=2;
        end
    end
    function ShowStatus()
        if MovieOn
            mccd(Stage)=mccd(Stage)-1;
            if mccd(Stage)==0;
                mccd(Stage)=MovieClearCountDown(Stage);
                h_plot=findobj(h_fitness(Stage),'Color','black');
                delete(h_plot)
                drawnow
            end
            delete(h_text);
            h_text=text(reporters,0,50,num2str(LowTribe(1:textsize(1),1:textsize(2)),'%.1f  '));
            plot(h_fitness(Stage),[Logs{Stage}(Logs_mark(Stage),1),Year(Stage)],...
                [Logs{Stage}(Logs_mark(Stage),4),FitnessValue(SortOfFitnessValue(end))],'.k-');
            plot(h_objective(Stage),[Logs{Stage}(Logs_mark(Stage),1),Year(Stage)],...
                [Logs{Stage}(Logs_mark(Stage),3),ObjectiveValue(SortOfFitnessValue(end))],'.k-');
            drawnow
        end
        showBest(LowTribe(1,:),AddationImformation);
    end
end


%如何避免强势基因是问题的关键所在，这个可以通过建立第二群落，保证一个相对隔离的环境实现
%注意，种群大小一定是偶数~~~
%这是一个完美的框架
%还要注意score的正负
%有一个问题，记录和可视化部分耦合太大了


%log如何设计是一个很重要的问题,很多问题都是这样的
%目前采用的是绝对精英策略，所以暂时不考虑objfun和fitnessfun
%对于这种具体问题所依赖的数据不同的问题，比较好的解决方法是用可变数组（属性加属性值对-->可扩展）
%matlab里的cell和struct天然可扩展，尤其是struct
%因为输入太多了是在不好看，干脆定义一个GaStrategy全部包括
%不会终结的程序员不是好程序员



%为了尽可能提高效率，应该减少参数传递，所以，尽可能使用global 及预分配空间
%如何设计遗传算法的记录系统，可视化系统，模块化真是很有难度的

%一般来说，有如下搭配方式:
%DiasterCountDown设置为inf，则为单种群进化
%DiasterCountDown设置很小，HighTribeMixMax设置很大则为快速进化