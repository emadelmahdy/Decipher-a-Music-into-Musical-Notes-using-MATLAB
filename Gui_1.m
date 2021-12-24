function varargout = Gui_1(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Gui_1_OpeningFcn, ...
                   'gui_OutputFcn',  @Gui_1_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before Gui_1 is made visible.
function Gui_1_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Gui_1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Gui_1_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;



function Pause_time_Callback(hObject, eventdata, handles)

function Pause_time_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Note_Callback(hObject, eventdata, handles)

function Note_CreateFcn(hObject, eventdata, handles)

function Time_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)



PAUSE_TIME=.25;

In_File='SIMPLE eine kleine nachtmusik - mozart.wav';

[y,Fs]= audioread(In_File);
T = readtable('ScaleFreqs.xlsx','Range','A4:B112');

End=length(y);

Sample_Period=Fs/4;

%for loop to divide the input music to group of samples
%and procces each part of samples to pridect musical note

i=1;
for v = 1:Sample_Period:End-1
   

   % extracting the current sound part of in this sample period to computer
   % headphone to hear it
   Sound_Signal=y(v:v+Sample_Period,1);
   sound(Sound_Signal,Fs);  
   
   % extracting the current sound part of in this sample period
   % doing fast fourier transform (FFT) of input signal to convert it to
   % frequency domain
   Input_Signal=y( v+1500 :  v+Sample_Period-1500 , 1 );
   N=length(Input_Signal);
   N1=ceil(N/2);
   INPUT_SIGNAL=fft(Input_Signal);
   INPUT_SIGNAL_abs=abs(INPUT_SIGNAL);
   INPUT_SIGNAL_abs_double=fftshift(INPUT_SIGNAL_abs);
   freq_axis=[0:N-1];
   freq_axis_double=(freq_axis-N1)*Fs/N;
   
   %find the frequency of the musical tone in this part of %samples
   [Max,Index]= max(INPUT_SIGNAL_abs_double); % first we search for the maximum amplitude of this sampled part              
   FREQ=freq_axis_double(Index);              % then, we use this index to find 
   rows = (T.Var2<=abs(FREQ(1,1))+3&T.Var2>(abs(FREQ(1,1))-3));
   x=T(rows,:);
   temp=x.Var1;
   
   %calculate time slot 
   t=v/Fs;
   t=round(t,2);
   
   
   Time(i,1)= num2cell(t);
   
   
   [m,n] = size(temp);
   if m==1
       Note(i,1)=temp;
   else
       Note(i,1)=num2cell(' ');
   end
   i=i+1;
   
   %send frequency and it's time slot to GUI Screan
   set(handles.Time,'string',t);
    if Max>=10
         set(handles.Note,'string',temp);
    else
         set(handles.Note,'string','Selience');
    end
    %pause code for .25 second
    pause(PAUSE_TIME);
end


xlswrite('Out_File.xlsx', Time);

xlswrite('Out_File.xlsx',Note,'B1:B224');
