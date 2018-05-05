function BestGen=myga5(GaStrategy)
%% ��ʼ�������в���
% ������Ϣ����
TribeSize           =GaStrategy.TribeSize;
GenSize             =GaStrategy.GenSize;
AddationImformation =GaStrategy.AddationImformation;
% ������Ϣ������Ӱ������Ĺؼ�
DiasterCountDown    =GaStrategy.DiasterCountDown;
HighTribeMixMax   =GaStrategy.HighTribeMixMax;
EvolutionYearMax    =GaStrategy.EvolutionYearMax;
TimeMax             =GaStrategy.TimeMax*60;%ʱ�䣬�Է��Ӽ�
% ��ʾ���Ʊ���
MovieOn             =GaStrategy.MovieOn;
MovieClearCountDown =GaStrategy.MovieClearCountDown;%��ʱ��ջ�ͼ�Ա��⿨������

%% ��ʼ����Ⱥ
HighTribe  =rand(TribeSize,GenSize);
LowTribe   =rand(TribeSize,GenSize);
GenChange  =rand(TribeSize,GenSize);
GenExchange=rand(TribeSize,GenSize);
MixGen     =zeros(TribeSize*3,GenSize);


%% ��ʼ�����в���&���ݼ�¼ϵͳ

tic%ʱ���¼��ʼ
Stage=1;
FinalRun=false;
Logs=cell(2,1);
Logs_mark=ones(2,1);
Logs{1}=zeros(100000,4);%��¼������ʱ�䡢fitnessfun��objfun
Logs{1}(1,:)=[0,toc(),NaN,-inf];
Logs{2}=zeros(1000,4);
Logs{2}(1,:)=[0,toc(),NaN,-inf];
CountDown=[DiasterCountDown HighTribeMixMax];
cd=CountDown;
Year=ones(3,1);%ʱ�����������͵Ȳ���ʱ�䣬�ߵȲ���ʱ�����ʱ��
generation=1;

mccd=MovieClearCountDown;
if MovieOn;h_fig=figure();hold on;end%��ʼ����
scrsz = get(0,'ScreenSize');
set(h_fig,'Position',scrsz)%ȫ����ʾ
textsize=zeros(2,1);
textsize(1)=min(TribeSize,14);
textsize(2)=min(GenSize,40);
subplot(2,4,1);hold on;  h_fitness(1)=gca;
subplot(2,4,2);hold on;h_objective(1)=gca;
subplot(2,4,3);hold on;  h_fitness(2)=gca;
subplot(2,4,4);hold on;h_objective(2)=gca;
subplot(2,4,5:8);axis([0 100 0 100]);reporters=gca;
h_text=text(reporters,0,50,num2str(LowTribe(1:textsize(1),1:textsize(2)),'%.1f  '));
h_text2=text(reporters,0,120,sprintf('��ǰ�ǵ�%d��Ⱥ���ѹ�ʱ��%d min,����%d min',...
generation,floor(toc()/60),ceil(TimeMax/60-toc()/60)),'color','red','fontsize',15);
set(reporters,'visible','off')




while true%��һ�����Ǻ��ģ�û�зŵ������ĺ�������д��һ���ǳ������ܿ���
    delete(h_text2);
    h_text2=text(reporters,0,120,sprintf('��ǰ�ǵ�%d��Ⱥ���ѹ�ʱ��%d min,����%d min',...
generation,floor(toc()/60),ceil(TimeMax/60-toc()/60)),'color','red','fontsize',15);
   %% �͵Ȳ������
    % ѡ��
    MixGen(:)=[LowTribe;GenChange;GenExchange];
    ObjectiveValue=objFun(MixGen,AddationImformation);
    FitnessValue=fitFun(ObjectiveValue);
    [~,SortOfFitnessValue]=sort(FitnessValue);
    LowTribe=MixGen(SortOfFitnessValue(end:-1:end-(TribeSize-1)),:);
    % ��¼�Ϳ��ӻ�����
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
    % ����
    GenChange(:)=LowTribe;
    mark=ceil(rand(TribeSize,2)*GenSize);
    mark=sort(mark,2);
    for aaa=1:TribeSize
        GenChange(aaa,mark(aaa,1):mark(aaa,2))=rand(1,mark(aaa,2)-mark(aaa,1)+1);
    end
    % ���滥��
    GenExchange(:)=LowTribe;
    ExchangeLength=size(GenExchange,1);
    ExchangSelect=randperm(ExchangeLength);
    mark=ceil(rand(ExchangeLength/2,2)*GenSize);
    mark=sort(mark,2);
    for aaa=1:ExchangeLength/2
        GenExchange([ExchangSelect(aaa),ExchangSelect(aaa+ExchangeLength/2)],mark(aaa,1):mark(aaa,2))=...
            GenExchange([ExchangSelect(aaa+ExchangeLength/2),ExchangSelect(aaa)],mark(aaa,1):mark(aaa,2));
    end
    % �ж��Ƿ�����л�
    if cd(Stage)==0;
        switch(Stage)
            case 1%�л����ߵȲ������
                Year(1)=1;
                Logs{1}=Logs{1}*0;
                Logs_mark(Stage)=1;
                Logs{1}(1,:)=[0,toc(),NaN,-inf];
                cd(Stage)=CountDown(Stage);
                GenChange(:)=LowTribe;
                LowTribe(:)=HighTribe;
                Stage=2;
            case 2%�л����͵Ȳ������
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
    %�ж��Ƿ���ֹ
    Year(Stage)=Year(Stage)+1;
    Year(3)=Year(3)+1;
    if FinalRun;break;end
    JudgeStop();
end

BestGen=LowTribe(1,:);

%% �������Ӻ���
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


%��α���ǿ�ƻ���������Ĺؼ����ڣ��������ͨ�������ڶ�Ⱥ�䣬��֤һ����Ը���Ļ���ʵ��
%ע�⣬��Ⱥ��Сһ����ż��~~~
%����һ�������Ŀ��
%��Ҫע��score������
%��һ�����⣬��¼�Ϳ��ӻ��������̫����


%log��������һ������Ҫ������,�ܶ����ⶼ��������
%Ŀǰ���õ��Ǿ��Ծ�Ӣ���ԣ�������ʱ������objfun��fitnessfun
%�������־������������������ݲ�ͬ�����⣬�ȽϺõĽ���������ÿɱ����飨���Լ�����ֵ��-->����չ��
%matlab���cell��struct��Ȼ����չ��������struct
%��Ϊ����̫�������ڲ��ÿ����ɴඨ��һ��GaStrategyȫ������
%�����ս�ĳ���Ա���Ǻó���Ա



%Ϊ�˾��������Ч�ʣ�Ӧ�ü��ٲ������ݣ����ԣ�������ʹ��global ��Ԥ����ռ�
%�������Ŵ��㷨�ļ�¼ϵͳ�����ӻ�ϵͳ��ģ�黯���Ǻ����Ѷȵ�

%һ����˵�������´��䷽ʽ:
%DiasterCountDown����Ϊinf����Ϊ����Ⱥ����
%DiasterCountDown���ú�С��HighTribeMixMax���úܴ���Ϊ���ٽ���