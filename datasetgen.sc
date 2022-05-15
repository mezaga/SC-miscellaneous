DataSetgen{
	*new{ |amount = 1000, path|
		amount.do{
			|i|
			postln(i)
		}
    }

	gen{
		^this.amount
	}
	play{
		//tocar los buffer
	}

	save{
		Buffer.alloc( Server.default,1000);
		///guardar los archivos
	}

	*am{|num,dur,freq,mod,profMod,atk,atkTime,dcy,dcyTime,sus,susTime,relTime|
		SynthDef(\am, {
	arg freq = 440, desv= 220, amp = 0.4, pan = 0, ampMod= 1, t_gate = 1, rel = 0.4, dcy = 0.2, atk = 0.1, sus = 0.5, out = 0, bufnum, curve = -1, segments = 5, smod = 10,emod = 20, dur = 4;
	var mod, port, env, envfreq, profMod, sig, envctl, buf;

	env = Env.newClear(5);
	envctl = \env.kr(env.asArray);
	env = EnvGen.kr(envctl,t_gate, doneAction:2);
	envfreq = Line.ar(smod,emod,dur);
	mod = SinOsc.ar(envfreq, 0, SinOsc.ar(ampMod), 0.5);
	port = VarSaw.ar(freq, 0,0.5, amp);
	sig = Normalizer.ar(port* mod, 1)* env;
	Out.ar(out, sig);

}).add;

r{
				num.do{|i|
				//postln(i);
				postln("aaaa");
				//b.value = 0;
				Synth(\am,[\freq,100,\smod,200,\emod,2000,\env,Env([0,1,1,1,0], [0.1,1,1,1], \lin)]);
				dur.wait;
				};}.play;


	}

	*fm{|num = 20, dur = 4,freq =220 ,mod=20 ,cRatio = 2 ,mRatio= 5 ,index= 1 ,atk= 1 ,atkTime = 0.3 ,dcy= 0.8, dcyTime = 0.4 ,sus= 0.8,susTime = 2, relTime = 4|
		SynthDef (\fm, {
	|freq= 200, modFreq= 20, ampm= 400, amp= 0.4, t_gate= 1,out = 0, ampmod = 2, bufnum, curve = -1, cRatio = 1, mRatio = 1, index = 1|
	var onda, env, sig, envctl,mod,indexMod;

	env = Env.newClear(5);
	envctl = \env.kr(env.asArray);
	env = EnvGen.kr(envctl,t_gate,doneAction:2);
	mod = SinOsc.ar(modFreq* mRatio,0,freq * mRatio* index);
	onda= SinOsc.ar(freq * cRatio + mod,0, amp);
	sig = Normalizer.ar(onda, 1) * env;
	RecordBuf.ar(sig,bufnum);
	Out.ar(out,sig)

}).add;

	r{
				num.do{|i|
				var envTime;
				//postln(i);
				postln("aaaa");
				envTime = [atkTime,dcyTime,susTime,relTime].normalizeSum * dur;
				Synth(\fm,[\freq,freq,\modFreq,mod,\cRatio,cRatio,\index,index,\env,
					Env([0,atk,dcy,sus,0],envTime, \lin)
				]);
				dur.wait;
				};}.play;

	}



	*waveshaping{
		SynthDef (\waveshapping, {
	|freq= 200, ampm= 400, amp= 0.4, pan= 0, t_gate= 1,fval= 5, min= 20, max= 1000, out = 0, ampmod = 2, bufnum, trans|
	var sig, env, envctl;

	env = Env.newClear(5);
	envctl = \env.kr(env.asArray);
	env = EnvGen.kr(envctl,t_gate,doneAction:2);
	sig= Shaper.ar(trans,SinOsc.ar(freq, 0, amp));
	sig = LeakDC.ar(Normalizer.ar(sig, 1))* env;
	RecordBuf.ar(sig,bufnum);
	Out.ar(out,sig)

}).add;

	}

	*granular{
		SynthDef(\singran,{
	|dens= 5, grdur= 0.1, amp= 0.1,  pan=0, out=0, t_gate =1, bufnum|
	var sig, freqs, env, envctl;
	env = Env.newClear(5);
	envctl = \env.kr(env.asArray);
	env = EnvGen.kr(envctl,t_gate,doneAction:2);
	freqs = \freqarray.kr([100,150,400,543,720],0.1);
	sig = Mix(GrainSin.ar(1, LFNoise0.ar(dens), grdur, freqs, pan));
	sig = Normalizer.ar(sig, 1) * env;
	RecordBuf.ar(sig,bufnum);
	Out.ar(out, sig);
}).add;
	}

	*sustractive{

SynthDef(\dklank, { |freq=100, amp= 0.5, dur=0.5, pan=0, out=0, rzfact=1,t_gate=1, bufnum|
	var nois, filts, env,envctl,sig, freqs, filamps, ringtimes;

	env = Env.newClear(5);
	envctl = \env.kr(env.asArray);
	env = EnvGen.kr(envctl,t_gate,doneAction:2);

	freqs = Control.names([\freqs]).kr([325,700,2530,3500,4950,0,0,0,0,0]);
	filamps = Control.names([\famps]).kr([0.2,0.1,0.05,0.25,0.125,0,0,0,0,0]);
	ringtimes = Control.names([\ringtimes]).kr([0.5,0.5,0.5,0.5,0.5,0,0,0,0,0]);
	nois= PinkNoise.ar(0.001);
	//nois= HPF.ar(nois,100);
	filts= DynKlank.ar(`[freqs, filamps, ringtimes], nois);
	sig= Mix(filts);
	sig = Normalizer.ar(sig, 1) * env;
	RecordBuf.ar(sig,bufnum);
	Out.ar(out, sig);
}).add;

	}


	*gui{

	}
}

