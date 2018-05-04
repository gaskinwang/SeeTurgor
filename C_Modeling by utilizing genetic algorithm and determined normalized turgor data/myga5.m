function BestGen=myga5(GaStrategy)
%% Initial operating parameters
% Basic variables
TribeSize           =GaStrategy.TribeSize;
GenSize             =GaStrategy.GenSize;
AddationImformation =GaStrategy.AddationImformation;
% Core variables--key for evolution
DiasterCountDown    =GaStrategy.DiasterCountDown;
HighTribeMixMax   =GaStrategy.HighTribeMixMax;
EvolutionYearMax    =GaStrategy.EvolutionYearMax;
TimeMax             =GaStrategy.TimeMax*60;%Time, in minutes
% Display control variables
MovieOn             =GaStrategy.MovieOn;
MovieClearCountDown =GaStrategy.MovieClearCountDown;%Regularly clear drawing to avoid machine jamming

%% Initialize population
HighTribe  =rand(TribeSize,GenSize);
LowTribe   =rand(TribeSize,GenSize);
GenChange  =rand(TribeSize,GenSize);
GenExchange=rand(TribeSize,GenSize);
MixGen     =zeros(TribeSize*3,GenSize);


%% Initialize operating parameters & Data recording system

tic%Time recording begins
Stage=1;
FinalRun=false;
Logs=cell(2,1);
Logs_mark=ones(2,1);
Logs{1}=zeros(100000,4);%Record evolutionary generation、时间time、fitnessfun、objfun
Logs{1}(1,:)=[0,toc(),NaN,-inf];
Logs{2}=zeros(1000,4);
Logs{2}(1,:)=[0,toc(),NaN,-inf];
CountDown=[DiasterCountDown HighTribeMixMax];
cd=CountDown;
Year=ones(3,1);%Three kinds of timers: lower tribal time, higher tribal time and total time
generation=1;

mccd=MovieClearCountDown;
if MovieOn;h_fig=figure();hold on;end%Initial screen
scrsz = get(0,'ScreenSize');
set(h_fig,'Position',scrsz)%full-screen display
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




while true%This part is the core part: Not written as a separate function but written together for performance reasons
    delete(h_text2);
    h_text2=text(reporters,0,120,sprintf('当前是第%d子群，已过时间%d min,还需%d min',...
generation,floor(toc()/60),ceil(TimeMax/60-toc()/60)),'color','red','fontsize',15);
   %% Low tribe updates
    % select
    MixGen(:)=[LowTribe;GenChange;GenExchange];
    ObjectiveValue=objFun(MixGen,AddationImformation);
    FitnessValue=fitFun(ObjectiveValue);
    [~,SortOfFitnessValue]=sort(FitnessValue);
    LowTribe=MixGen(SortOfFitnessValue(end:-1:end-(TribeSize-1)),:);
    % Record and Visualize
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
    % variation
    GenChange(:)=LowTribe;
    mark=ceil(rand(TribeSize,2)*GenSize);
    mark=sort(mark,2);
    for aaa=1:TribeSize
        GenChange(aaa,mark(aaa,1):mark(aaa,2))=rand(1,mark(aaa,2)-mark(aaa,1)+1);
    end
    % Crossover
    GenExchange(:)=LowTribe;
    ExchangeLength=size(GenExchange,1);
    ExchangSelect=randperm(ExchangeLength);
    mark=ceil(rand(ExchangeLength/2,2)*GenSize);
    mark=sort(mark,2);
    for aaa=1:ExchangeLength/2
        GenExchange([ExchangSelect(aaa),ExchangSelect(aaa+ExchangeLength/2)],mark(aaa,1):mark(aaa,2))=...
            GenExchange([ExchangSelect(aaa+ExchangeLength/2),ExchangSelect(aaa)],mark(aaa,1):mark(aaa,2));
    end
    % Determine whether to switch
    if cd(Stage)==0;
        switch(Stage)
            case 1%Switch to the high tribe update
                Year(1)=1;
                Logs{1}=Logs{1}*0;
                Logs_mark(Stage)=1;
                Logs{1}(1,:)=[0,toc(),NaN,-inf];
                cd(Stage)=CountDown(Stage);
                GenChange(:)=LowTribe;
                LowTribe(:)=HighTribe;
                Stage=2;
            case 2%Switch to the low tribe update
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
    %determine whether to terminate
    Year(Stage)=Year(Stage)+1;
    Year(3)=Year(3)+1;
    if FinalRun;break;end
    JudgeStop();
end

BestGen=LowTribe(1,:);

%% Functional subfunctions
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


%How to avoid the appearence of strong genes is the key. This can be achieved by establishing a second community and ensuring a relatively isolated environment.
%Note that the population size must be an even number~~~
%Also pay attention: score is + or -
%Absolute elite strategy

%In general:
%DiasterCountDown is set as inf: single population evolution
%When DiasterCountDown was set to a small value while HighTribeMixMax was vary big, it will evalue evolve rapidly.