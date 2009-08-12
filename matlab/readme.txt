This is the MT-IVM toolbox. 

Unfortunately the software here will not exactly recreate the experiments in the ICML paper as, due to the anonymous submission procedure I failed to freeze the code after submission. My apologies for this.

The original ICML version relied on old IVM code that predates the version on the web. This version relies on the new IVM toolbox which is a lot more modular.

This code relies on the IVM toolbox vs 0.31. You can use your username and password to download this toolbox from http://www.dcs.shef.ac.uk/~neil/ivm/downloadFiles/. Additionally you will require the drawing toolbox, available from http://www.dcs.shef.ac.uk/~neil/drawing/downloadFiles/.

Finally you will also need the NETLAB toolbox (http://www.ncrg.aston.ac.uk/netlab/) in your path.

Version 0.142
-------------

Fixes to icmlVowelDemo.

Version 0.141
-------------

Just a freshen up release before talks given in Madrid. Mainly to redo plots for toy problem etc..

Version 0.14
------------

Thanks to Kevin Murphy for pointing out some bugs, including the failure of icmlClassification.m to run. The bug occured when no points from a particular task were selected (i.e. the task was considered uninformative) and the algorithm tried to measure the likelihood of that task.
