+SimpleNumber{
	speakersCheck{|time = 0.1,amp = 0.01|
		var speakers = this;
		r{
			speakers.do{|i|
			{|out = 0, t_gate = 1|
					PinkNoise.ar(amp)*EnvGen.kr(Env.perc(0.1,0.1,curve:-2),t_gate,doneAction:2);
}.play(outbus:i);
				time.wait;
		}}.play;
	}

}