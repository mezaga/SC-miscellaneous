//AM
"datasetSynths.scd".loadRelative;

~folder = ["/Volumes/Gerardo HD/sintesis_dataset/am/",
"/Volumes/Gerardo HD/sintesis_dataset/fm/",
	"/Volumes/Gerardo HD/sintesis_dataset/waveshapping/",
	"/Volumes/Gerardo HD/sintesis_dataset/grain/",
	"/Volumes/Gerardo HD/sintesis_dataset/res/"
];


r{

200.do{|i|

var nota, envelope,envelope2;
	~v = Buffer.allocConsecutive(5,s,s.sampleRate* 4, 1);
	~b = Buffer.alloc(s, 512, 1, { |buf| buf.chebyMsg({rrand(0.01,1.0)}!rrand(4,5))});
	~b.plot;

	nota = rrand(36.0,48).midicps;
	postln(nota.cpsmidi);




a= Synth(\am,[\freq,nota,\desv,4.rand,\ampMod,20.rand,
			\smod,rrand(10,200),
			\mmod,rrand(10,400),
			\env,Env([0,{rrand(0.01,1)}!3,0].flatten,4.partition(4,0.0001),rrand(-4,4.0)),
	\desv,rrand(48.0,72.0).midicps,
	\bufnum,~v[0],
	\out,40,
]);

b= Synth(\fm,[\freq,nota*2,\modFreq,rrand(20,2000),
	\cRatio,20.rand,\mRatio,40.rand,\index,rrand(0.1,1),
	\env,Env([0,{rrand(0.01,1)}!3,0].flatten,4.partition(4,0.0001),rrand(-4,4.0)),
	\out,45,
	\bufnum,~v[1],
]);

c = Synth(\waveshapping,[\freq,nota*3,
	\trans,~b,
	\env,Env([0,{rrand(0.01,1)}!3,0].flatten,4.partition(4,0.0001),rrand(-4,4.0)),
	\out,50,
	\bufnum,~v[2],

	]);

d = Synth(\singran,[
	\grdur,rrand(0.01,0.4),
	\dens,rrand(3,40),
	\env,Env([0,{rrand(0.01,1)}!3,0].flatten,4.partition(4,0.0001),rrand(-4,4.0)),
	\out,55,
	\freqarray,[nota*4,{rrand(40,15000)}!4].flatten,
	\bufnum,~v[3],
		]);


f = Synth(\dklank,[
			\env,Env([0,{rrand(0.01,1)}!3,0].flatten,4.partition(4,0.0001),rrand(-4,4.0)),
			\freqs,[nota*5,{rrand(200,2000)}!10].flatten,
			\out,60,
			\famps,({exprand(0.05,1)}!10),
			\ringtimes,({rrand(0.4,4)}!10),
			\bufnum,~v[4]
			]);


	4.wait;
		~v[0].write(~folder[0]++"am_"++i++".wav","wav",'int24');
		~v[1].write(~folder[1]++"fm_"++i++".wav","wav",'int24');
		~v[2].write(~folder[2]++"ws_"++i++".wav","wav",'int24');
		~v[3].write(~folder[3]++"grain_"++i++".wav","wav",'int24');
		~v[4].write(~folder[4]++"res_"++i++".wav","wav",'int24');


		postln("done"++" "++i);
	};

	postln("finalizado");
}.play;

/////
w = ();
w.win = Window("DataSetGenerator",Rect(15.0, 812.0, 1011.0, 720.0));
w.font = Font("Helvetica", 14,true);
//w.win.bounds
w.win.view.background = Color(0.6, 0.55, 0.6, 0.975);
w.view = CompositeView(w.win, Rect(5, 5,(w.win.bounds.width- 10), (w.win.bounds.height- 40)));
w.view.decorator = q = FlowLayout(w.view.bounds);
w.view.background = Color(0.3, 0.2, 0.3, 0.5);

w.freqctl = ControlSpec(20,20000,units:"hz");
w.ampctl = ControlSpec(0.0,1.0,units:"amp");


w.labelsbtn = ["AM","FM", "WaveShapping","Granular", "Sustractive"];

w.buttons = w.labelsbtn.collect{|item,i| Button(w.view,Rect(10,20,(w.view.bounds.width/5.2),40)).states_([
	[item,Color.black],[item,Color.black,Color.red]
];)};

w.labels = [
	"Freq","Mod","ProfMod","Atk","AtkTime","Dcy","DcyTime","Sus","SusTime","relTime",
	"Freq","Mod","CRatio","MRatio","index","Atk","AtkTime","Dcy","DcyTime","Sus","SusTime","relTime",
	"Freq","Atk","AtkTime","Dcy","DcyTime","Sus","SusTime","relTime","TrasferA","TrasferH",
	"GrainDur","Events", "Atk","AtkTime","Dcy","DcyTime","Sus","SusTime","relTime",
	"Freq","Freqs","amps", "RTimes","Atk","AtkTime","Dcy","DcyTime","Sus","SusTime","relTime"

];

~b = Dictionary.new;


w.am = [[20,20000,\freq],[0,4000,"Hz"],[0.0,1.0,"amp"],[0,1.0,"amp"],[0,100,"%"],[0,1.0,"amp"],[0,100,"%"],[0,1,"amp"],[0,100,"%"],[0,100,"%"]];


w.text = StaticText(w.view,Rect(0,0,w.view.bounds.width,15));
w.text.string = "AM";
w.text.align = \center;
w.text.font = w.font;
w.rangers1 = 10.collect{|k,item|
	EZRanger(
		w.view,Rect(30,10,(w.view.bounds.width/2.2),15),w.labels[k],
		ControlSpec(w.am[k][0],w.am[k][1],units:w.am[k][2]));};

////asignacion de valores del slider a etiquetas para Synths
w.amVal = w.rangers1.do{|ez,i|
	postln(ez);
	ez.action = {|v| ~b.put(w.labels[i].asSymbol, v.value)}};


w.fm = [[20,20000,\freq],[0,4000,"Hz"],[0,100,"amp"],[0,100,"amp"],[0,1,"%"],[0,1.0,"amp"],[0,100,"%"],[0,1,"amp"],[0,100,"%"],[0,1,"amp"],[0,100,"%"],[0,100,"%"]];


w.text = StaticText(w.view,Rect(0,0,w.view.bounds.width,15));
w.text.string = "FM";
w.text.align = \center;
w.text.font = w.font;
w.rangers2 = 12.collect{|k|EZRanger(w.view,Rect(30,10,(w.view.bounds.width/2.2),15),w.labels[(10+k),ControlSpec(w.fm[k][0],w.fm[k][1],units:w.fm[k][2])])};//,w.labels[btn][k]);};

w.wave = [[20,20000,\freq],[0,1.0,"amp"],[0,100,"%"],[0,1,"amp"],[0,100,"%"],[0,1,"amp"],[0,100,"%"],[0,100,"%"],[0,1.0,"amp"],[0,30,"harms"]];


w.text = StaticText(w.view,Rect(0,0,w.view.bounds.width,15));
w.text.string = "WaveShapping";
w.text.align = \center;
w.text.font = w.font;
w.rangers3 = 10.collect{|k|EZRanger(w.view,Rect(30,10,(w.view.bounds.width/2.2),15),w.labels[22+k],ControlSpec(w.wave[k][0],w.wave[k][1],units:w.wave[k][2]))};


w.grain = [[0,2.0,"dur"],[0,20,"events"],[0,1,"amp"],[0,100,"%"],[0,1,"amp"],[0,100,"%"],[0,1,"amp"],[0,100,"%"],[0,100,"%"],[0,1.0,"amp"],[20,20000,"freqs"]];

w.text = StaticText(w.view,Rect(0,0,w.view.bounds.width,15));
w.text.string = "Granular";
w.text.align = \center;
w.text.font = w.font;
w.rangers4 = 10.collect{|k|EZRanger(w.view,Rect(30,10,(w.view.bounds.width/2.2),15),w.labels[32+k],ControlSpec(w.grain[k][0],w.grain[k][1],units:w.grain[k][2]))};


w.sus = [[20,20000,"hz"],[20,20000,"hz"],
	[0,1,"amp"],[0.0,4,"%"],[0,1,"amp"],[0,100,"%"],[0,1,"amp"],[0,100,"%"],[0,1.0,"amp"],[0,100,"%"],[0,1.0,"amp"]];


w.text = StaticText(w.view,Rect(0,0,w.view.bounds.width,15));
w.text.string = "Sustractiva";
w.text.align = \center;
w.text.font = w.font;
w.rangers5 = 11.collect{|k|EZRanger(w.view,Rect(30,10,(w.view.bounds.width/2.2),15),w.labels[41+ k],ControlSpec(w.sus[k][0],w.sus[k][1],units: w.sus[k][2]))};


w.gen = Button(w.win,Rect(4,(w.win.bounds.height-30),(w.win.bounds.width-20),28
)).states_([["Generate",Color.black],["Generate",Color.black,Color.red]]);


w.sliderNum = EZSlider(w.view,Rect(0,0,(w.view.bounds.width-30),20),"Amount",ControlSpec(0,10000,step:1));
w.sliderNum.action_({|ez| ~val = round(ez.value); postln(round(~val))});

w.arry = Array.fill(5, { arg i; i =0 });

w.buttons.do{|item,i|
	item.action = {|b|
	postln(item);
	//postln(b.value);
	if(b.value == 1){
		w.arry[i] = 1;
		postln(w.arry);
	}{
		w.arry[i] = 0;
		postln(w.arry);
	};


};
};


w.gen.action = {|b|
	var nota;
	nota = 60.midicps;
	//postln(b.value);

	if(b.value == 1){
		postln("todochidp");
		w.buttons.do{|item, i|
		if(w.arry[i] == 1){
				r{
				200.do{
				//postln(i);
				postln("aaaa"++i);
				//b.value = 0;
				w.synths[i].value;
				4.wait;
				};}.play;

		};
		}{

		};


}};


w.win.front;


a = [rand(12,20),rand(12,20),rand(12,20),rand(12,20),rand(12,20)].normalizeSum * 4;
a.sum





w.synths= [
	{Synth(\am,[\freq,100,\desv,4.rand,\ampMod,20.rand, \smod,rrand(10,200),\mmod,rrand(10,400),
			\env,Env([0,{rrand(0.01,1)}!3,0].flatten,4.partition(4,0.0001),rrand(-4,4.0)),\desv,rrand(48.0,72.0).midicps,\bufnum,~v[0],\out,0]);

	}
	,{
	Synth(\fm,[\freq,100*2,\modFreq,rrand(20,2000),
	\cRatio,20.rand,\mRatio,40.rand,\index,rrand(0.1,1),
	\env,Env([0,{rrand(0.01,1)}!3,0].flatten,4.partition(4,0.0001),rrand(-4,4.0)),
	\out,45,
	\bufnum,~v[1],
]);


},{
	Synth(\waveshapping,[\freq,100*3,
	\trans,~b,
	\env,Env([0,{rrand(0.01,1)}!3,0].flatten,4.partition(4,0.0001),rrand(-4,4.0)),
	\out,50,
	\bufnum,~v[2],

	]);

},
	{Synth(\singran,[
	\grdur,rrand(0.01,0.4),
	\dens,rrand(3,40),
	\env,Env([0,{rrand(0.01,1)}!3,0].flatten,4.partition(4,0.0001),rrand(-4,4.0)),
	\out,55,
	\freqarray,[100*4,{rrand(40,15000)}!4].flatten,
	\bufnum,~v[3],
		]);


},{Synth(\dklank,[
			\env,Env([0,{rrand(0.01,1)}!3,0].flatten,4.partition(4,0.0001),rrand(-4,4.0)),
	\freqs,[100*5,{rrand(200,2000)}!10].flatten,
			\out,60,
			\famps,({exprand(0.05,1)}!10),
			\ringtimes,({rrand(0.4,4)}!10),
			\bufnum,~v[4]
]);}

];

