function q = playmidi(nmat, tempo);
% Plays a notematrix using a MIDI program
% q = playmidi(nmat, <tempo>);
% Creates a temporary MIDI file and plays it using a suitable program
%
% Input argument: 
%     NMAT = Notematrix
%     TEMPO (optional)= tempo (default 120 bpm)
%
% Output: Opens up MIDI Player and plays temp.mid in the player.
%
% Remarks: The player depends on the operating system (Macintosh, PC, Linux). 
%
% Example : playmidi(nmat,145);
%   plays nmat with the tempo 145 beats per minute;
%
% Authors:
%  Date		Time	Prog	Note
% 2.1.2003	18:41	TE	Created under MATLAB 5.3 (PC)
%� Part of the MIDI Toolbox, Copyright � 2004, University of Jyvaskyla, Finland
% See License.txt

if isempty(nmat) return; end
if nargin<2, tempo = 120; end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 0: Add some padding to the end of NMAT (nicer sounding...)
padding = [nmat(end,1)+nmat(end,2) 1 1 60 0 nmat(end,6)+nmat(end,7) 0.5];
nmat=[nmat; padding];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ifn = [tempname,'.txt']; ofn = [tempname,'.mid'];

% 1: Convert NMAT to text file
nmat2mft(nmat, ifn, 120, tempo, 4, 4);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2: Convert text file to MIDI
% dpwe: no longer platform dependent (although mft2mf is)
mft2mf(ifn,ofn);
delete(ifn);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 3: play MIDI
% 	OBS: PLATFORM DEPENDENT
if strcmp(computer,'PCWIN') | strcmp(computer,'GLNX86')
   fprintf(1,'Checking for MIDI player... ');
   player=setmidiplayer;
   if ~isempty(player)==1
      disp('found')
   else
      disp('not found')
      return
   end
   if strcmp(computer,'PCWIN')
     cmd = ['dos(''','"',player,'"',' ' ofn,''');'];
   else % Linux
     cmd = [player,' ',ofn];
   end
   system(cmd)
   delete(ofn);
elseif strcmp(computer,'MAC')
   cmd = ['! open -a /Applications/''QuickTime Player.app'' ''' ofn ''''];    
   eval(cmd);
   disp('Press space bar to listen to the MIDI file.');
   disp('Close the Quicktime Player window after listening.');
else
   disp('This function works only on Macintosh OS X / Windows / Linux!');
   return;
end
