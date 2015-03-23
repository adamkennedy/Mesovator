# Mesovator

A 4-hour implementation of an elevator control system

# Preamble

(Oh god, a preamble. So you're probably yawning already and about to ignore the rest of this and go straight to the code. I'm yawning as I read this and I wrote it... Fair enough. But then come back and read why it's the way it is afterwards. You can skip the bit about exploiting the testing process if you're in a hurry)

The project is tasked as follows:

    The challenge is intended to help us evaluate your problem solving and development skills.
    Our recommended approach is to develop a working bare-minimum framework, and then expand
    on your ideas in the time remaining. It is better to have a solution that runs but is 50%
    complete, rather than one that doesn't run and is 99% complete. 
    
    You have 4 hours to complete this challenge. Your time will start when you download the
    challenge (click the link) and ends when you mail the results back to us (either as an
    attached archive or a link to a GitHub repository). You can start whenever you would like,
    but please allocate a 4 hour block of time to complete the challenge. 

Additional verbal guidance is provided as follows (paraphrased):

    The problem is related to elavator control systems. We are examinining both your development
    approach and your testing, documentation approach. Some of us were joking that it would be
    fun to see you do it in Perl.

# Metaconsiderations

This repository contains an implementation of an elevator control system, with treatment of the task as a completely serious real world effort but with an artificially contrained time limit for the implementation.

## Language Choice

For the sake of maximum amusement to the Mesosphere development team, and in consideration of the speed-development nature of the problem and language familiarity, I shall complete the task (primarily) in Perl.

Obviously, for any real form of elavator control system Perl is a horrible choice. But in this case, given the very short timeline and the open scope of the problem (to be discussed later) Perl's native testing infrastructure is actually pretty amenable to churning out lots of hacky but effective tests.

## Programming Paradigm

My preference for this would be to use an implementation based on an event model to get something vaguely soft-realtime capable.

I've actually written a library in the past that would be a nice fit for this problem (see http://search.cpan.org/perldoc?POE::Declare) but I'm not going to use it in this case. Even with the strictness and structure provided by POE::Declare, writing decent event model programs can be time consuming.

Testing it can be tricky at times as well, especially if you leave any timers of handles around which might prevent the event loop from exiting (although I did previously write http://search.cpan.org/perldoc?Test::POE::Stopping to deal with this issue).

Further, while using an event model might be fine for running tests in real time, I'm not sure it's a very good idea for this kind of initial simulator work. A much simple approach with our own synthetic event loop should make it much easier for tests to run an entire day's simulation quickly without considering to real wall-clock issues.

So while it's totally unrealistic in any real world scenario, I'm going to embed my own event loop in the simulator for the sake of expediency.

## Potential Flaws in the Mesosphere Take Home Test

The majority of this document is being written before starting the timer on the Take Home Test.

Depending on what your purpose is with this test, it can be seen as having flaws that are potentially exploitable although it's hard to say if this is intentional or not. Perhaps you actually WANT to test the ambition and moxie of your candidates and are happy to have them exploit these flaws.

Firstly, the suggestion in the email above of using "a link to a GitHub repository" to submit code results in any candidate using this approach leaving details of both the test and their implemenation visible to future people taking this test (as private repository usage involves a fee).

Combined with the detail of the problem being elevator-related, this allows numerous previous implementations to be discoverable via a trivial Google search.

http://lmgtfy.com/?q=mesosphere+elevator

Numerous examples can also be found with an even simpler "mesosphere" search on GitHub.

https://github.com/search?o=desc&q=mesosphere&s=updated&type=Repositories&utf8=%E2%9C%93

Side Note: Take a look at end of that URL in a browser. utf8=(unicode check mark / yes)...? Someone at GitHub is a smart-ass :)

That said, nobody on that list of repositories appears in the list of new hires at Mesosphere...

https://mesosphere.com/blog/categories/new-hire/

... so none of them are worth investigating very much or (god forbid) forking.

That said, it does mean the secret is blown in terms of what the problem is.

For my implementation, I have taken some advantage of this in terms of background research and time to think about an implementation strategy, but I've tried to stay true to the spirit of the test by making sure all the code and implementation in this repository was written inside of the 4 hour window.

With all that said, if your intention is to actually have this challenge be a secret then I would recommend not giving the option for people to use a public GitHub repository.

Then again, completely preventing any knowledge of the problem is going to skew your testing bias towards Top Coder types and recent grads who have trained on speed-coding and that may not be a bias you want for a high-reliability product like DCOS.

Again, I'm not sure precisely your intent with the test, but if you don't intent people to find out in advance or have the potential to plagiarise/fork other people's work, then perhaps one option is to find a new challenge, only allow submissions via non-public channels, but provide the topic area a day in advance  so people have time to familiarise themselves with the problem domain before doing the specific challenge?

ith consideration to the above suggestion of limiting coding to the 4 hours but taking the option to educate myself on the problem domain in advance, I allowed myself some background research on the problem domain and potential implementation strategies.

## Exploitability of the Download Website

The website link provided to download the challenge is not only trivially exploitable, but is accidentally exploited by the auto-linking in gmail.

The "=" sign is not recognised by the Gmail auto-linked, and clicking on the link results in *[suppressed]/index.html?submitter* rather than *[suppressed]/index.html?submitter=adam@ali.as*. And the resulting link works, providing no trace of when I started the challenge.

For the record, it was in the vicinity of 2015-03-22 6:05pm San Francisco Time.

## Background Research

Elevator control is an interesting problem domain for a speed-implementation test.

To provide a general grounding in the field identified and purchased one of the definitive books on the field, *Elevator Traffic Handbook: Theory and Practice* by Dr Gina Barney (Kindle Edition. Physical would be nicer but $200+ is a little pricey)

http://www.amazon.com/Elevator-Traffic-Handbook-Theory-Practice-ebook/dp/B000SH1ZS6/ref=tmm_kin_title_popover?ie=UTF8&qid=1427069026&sr=8-2

Reading the book identifies several critical engineering issues relating to elevator design:

### Non-Generalisable

In the single-elevator case, there are some simple algorithms which provide a reasonable optimum strategy.

http://en.wikipedia.org/wiki/Elevator_algorithm

There is no simple optimum strategy for scheduling multiple elevators.

Real world multiple elevator control strategies can be extremely complex, including fuzzy logic, machine learning and neural net approaches.

### Elevator Strategy is Inseparable from Building Context

An issue repeatedly reinforced by Dr Barney is that elevator implementations are based on the traffic characteristics of a specific building.

The type of building, density and timing of the Up Peak and Down Peak, and the nature of the passenger trips is integrally bound to the implementation strategy for the elevator controller. Strategies such as load rating, zone allocation, floor priorities, and pre-location of idle elevators all emerge from the specific requirements of each building.

The testing strategy MUST be able to be related to specific scenarios that can be modeled based on passenger simulations or real world recordings of passenger movements.

### Multiple Metrics of Success

The success or failure of an elevator system can not only be difficult to test, but the criteria themselves may be difficult to test or statistical in nature.

For example, a common constraint in office buildings deals with passenger impatience during the end-of-workday peak. A 90 seconds time limit exists before the passenger incurs psychological stress. A passenger may be happy to wait longer during a morning or mid-day trip without similar stress occuring.

Numerous metrics such as wait time, travel time, stop count and elevator load rating (how full it is) all impact passenger stress and should be possible in the testing framework, along with testing pass/fail measures that statistic measures (best, worst, mean, median and percentile measures).

## Prior Art

With a requirement in place for a simulator of some kind with real world scenario tests, I did a search for prior art in this area.

The most applicable and interesting of these is the following...

http://play.elevatorsaga.com/

I briefly considered forking this game and using it as my simulator platform, but that would involve creating the solution in Javascript, and a risk that modifications to the platform will be more complex than expected (the game would have to be wrapped in a testing harness, it doesn't current support deterministic random event generation, and so on).

The API exposed by the programming game does provide an excellent precedent for what events should be available on the controller, as significant thought has already been put into modelling elevator behaviour in a manner somewhat similar to real scenarios.

http://play.elevatorsaga.com/documentation.html

The game also provides extensive prior art on different algorithms for elevator control and strategies for the solution.

https://github.com/magwo/elevatorsaga/wiki/Solutions

Taking a random survey of the different "advanced" solutions shows that a relatively optimal implementation of an elevator controller, with the simulator already provided, costs around 500-1000 lines of code.

Considering the 4 hour time limit, an implementation of this size is infeasible.

However, some of the more simple strategies fall into the 50-100 range with an algorithm compresensible on a simple reading of the Javascript and should be easy enough to port to a different language and simulator environment.

The collection of implementation strategies also provides excellent input on the different simulator features necesary and the relative priority for implementation based on how frequently they are used.

## Implementation Strategy

With consideration of the above, my approach for this project (once I get a chance to see the details) will be based on the following.

1. I am being considered specifically for what I consider to be a foundational testing role, so clearly a focus on this area will help you decide if I'm worthy to be the guy that breaks your stuff on a regular basis.

2. Assuming this problem is to design an elevator control system for the multiple case, testing and simulation is far more important for this project than in a more typical problem, for reasons outlined in the Background Research section below. This reinforces the importance of this area of work on this project.

3. The codebase will support a common controller interface with multiple controller implementations (implemented naively without the use of rigourous interface extensions to Perl due to the time consideration).

4. The simulator will support a "passenger schedule" in which passenger movements are provided in a pre-generated CSV file, decoupling creation of the schedule from execution of the schedule and allowing the production of complex testing scenarios using real-world logs or demand-simulations written in R, MATLAB, etc.

In the situation that the test problem involves a single elevator, a controller will be provided based on the Elevator Algorithm with the addition of a ground floor idle park.

In the situation that the test problem involves multiple elevators, no attempt will be made at an optimal solution but a collection of trivial controllers will be written or ported over from the Elevator Saga solutions.

# Commentary

Please see implementation commentary automatically timestamped via the commit log in GitHub.
