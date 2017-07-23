declare function bodyang{
DECLARE PARAMETER body1.
DECLARE PARAMETER body2.

SET body1p TO body1:position - body1:body:position.
SET body2p TO body2:position - body1:body:position.	
SET phaseangle TO ARCTAN2(body1p:x,body1p:z) - ARCTAN2(body2p:x,body2p:z).	

if phaseangle < -180 { 
	SET phaseangle TO phaseangle + 360.
}.	
if phaseangle > 180 {
	SET phaseangle TO phaseangle - 360.
}.
return phaseangle.
}

set phase_angle to 44.36.
set deltaV to 980.
set ejeAngle to 103.
lock actualang to bodyang(kerbin,duna).

wait 3.
set warp to 6.
wait 1.
set warp to 7.
wait 1.
set warp to 8.
until abs(actualang-phase_angle) < 0.05{
	clearscreen.
	print "Phase angle between kerbin and Duna = " +actualang.
	print "Waiting for desired phase angle = " +phase_angle.
	wait 0.1.
}
set warp to 0.
unlock actualang.
clearscreen.

SET STEERINGMANAGER:ROLLPID:KP TO 0.
SET STEERINGMANAGER:ROLLPID:KI TO 0.

wait 5.
gear off.
lock throttle to 1.
wait 2.
stage.
set booster to ship:partstagged("booster").
set sop to ship:partstagged("fout").
set dep to ship:partstagged("fin").
set lfuel to TRANSFERALL("LIQUIDFUEL",sop,dep).
set oxi to TRANSFERALL("OXIDIZER",sop,dep).

set pitch to 90.
set pRate to 1.75.
lock steering to heading(90,pitch).

wait until altitude > 2000.

when altitude > 4000 then{
	set lfuel:active to true.
	set oxi:active to true.
}

when pitch < 0 then{
	set pitch to 0.
}
when altitude > 55000 then{
	ag2 on.
}
when booster[1]:fuelflow < 0.001 then{
	stage.
}

until pitch < 0 {
	set pitch to 90 - altitude / 1000 * pRate + 2 * pRate.
}

wait until apoapsis > 690000.
lock throttle to 0.
wait 3.
stage.
rcs on.
wait 13.
rcs off.
wait 1.
set warpmode to "RAILS".
warpto(time:seconds+eta:apoapsis-35).
wait 15.
rcs on.
wait until eta:apoapsis < 2.
lock throttle to 1.
wait until periapsis > 685000.
lock throttle to 0.
wait 3.

lock realshipang to vectorangle(ship:velocity:orbit,kerbin:body:position).
set vec1 to 0.
set vec2 to 0.
set shipang to 0.
set anglespeed to 0.07.
wait 1.
set warp to 3.
until shipang > 179 AND shipang < 179.5{
	set vec1 to realshipang.
	clearscreen.
	print "Angle between kerbin's prograde and ship position "+shipang.
	print "deg/sec = " + anglespeed.
	wait 0.05.
	set vec2 to realshipang.
	set shipang to realshipang*(vec1-vec2)/abs(vec1-vec2).
	
	if shipang < -176.5{
		set warp to 0.
	}
}
set manev to node(time:seconds+(abs(shipang-ejeAngle)/anglespeed),0,0,deltaV).
add manev.
lock steering to manev:deltav.
set target to Duna.
wait 1.
warpto(time:seconds + manev:eta-40).

wait until manev:eta < 10.
rcs off.
lock throttle to 1.
set burnDeltaV to 0.
set vel1 to velocity:orbit:mag.
until burnDeltaV > deltaV{
	set burnDeltaV to abs(vel1 - velocity:orbit:mag).
	clearscreen.
	print "DeltaV = " + burnDeltaV.
	wait 0.05.
}
rcs on.
lock throttle to 0.
lock steering to heading(90,0).

wait 13.
rcs off.
stage.
remove manev.
wait 10.
ag3 on.
clearscreen.
print "Goodbye Kerbin!".
wait 8.
set manev to node(time:seconds+116000, 0,0,0).
add manev.
until manev:eta < 10000{
	set warp to 6.
}
set warp to 0.
wait 3.
remove manev.
lock steering to heading(90,45).
wait 20.
wait 2.
rcs on.
set warpmode to "PHYSICS".

set z to 0.
set ship:control:fore to 1.
set pe1 to 1.
set pe2 to 0.
set patcher to ship:patches.
until (pe1-pe2)<-1000{
	set patcher to ship:patches.
	if patcher:length > 1{
		set pe1 to patcher[1]:periapsis.
		wait 0.05.
		set pe2 to patcher[1]:periapsis.
		if patcher[1]:periapsis < 250000{set z to 1. set ship:control:fore to 0. break.}
	}
}
set ship:control:fore to 0.
wait 1.

if z = 0 {
	set ship:control:top to 1.
	set pe1 to 1.
	set pe2 to 0.
	wait 0.1.
	until (pe1-pe2)<-1000{
		set patcher to ship:patches.
		if patcher:length > 1{
			set pe1 to patcher[1]:periapsis.
			wait 0.05.
			set pe2 to patcher[1]:periapsis.
			if patcher[1]:periapsis < 250000{set z to 1. set ship:control:top to 0. break.}
		}
	}
}
set ship:control:top to 0.
wait 1.

if z = 0 {
	set ship:control:top to -1.
	set pe1 to 1.
	set pe2 to 0.
	wait 0.1.
	until (pe1-pe2)<-1000{
		set patcher to ship:patches.
		if patcher:length > 1{
			set pe1 to patcher[1]:periapsis.
			wait 0.05.
			set pe2 to patcher[1]:periapsis.
			if patcher[1]:periapsis < 250000{set z to 1. set ship:control:top to 0. break.}
		}
	}
}
set ship:control:top to 0.
wait 1.

if z = 0 {
	set ship:control:starboard to 1.
	set pe1 to 1.
	set pe2 to 0.
	wait 0.1.
	until (pe1-pe2)<-1000{
		set patcher to ship:patches.
		if patcher:length > 1{
			set pe1 to patcher[1]:periapsis.
			wait 0.05.
			set pe2 to patcher[1]:periapsis.
			if patcher[1]:periapsis < 250000{set z to 1. set ship:control:starboard to 0. break.}
		}
	}
}
set ship:control:starboard to 0.
wait 1.

if z = 0 {
	set ship:control:starboard to -1.
	set pe1 to 1.
	set pe2 to 0.
	wait 0.1.
	until (pe1-pe2)<-1000{
		set patcher to ship:patches.
		if patcher:length > 1{
			set pe1 to patcher[1]:periapsis.
			wait 0.05.
			set pe2 to patcher[1]:periapsis.
			if patcher[1]:periapsis < 250000{set z to 1. set ship:control:starboard to 0. break.}
		}
	}
}
set ship:control:starboard to 0.
wait 1.

set ship:control:neutralize to true.
unlock steering.
sas on.

wait 3.

set warpmode to "rails".
wait 1.
rcs off.
wait 5.

until eta:transition < 203000 {
	set warp to 8.
}

until eta:transition < 23000 {
	set warp to 7.
}

until eta:transition < 2300 {
set warp to 5.
}
until eta:transition < 80 {
	set warp to 3.
}
set warp to 0.
wait until eta:transition < 5.
wait 15.
set sasmode to "radialin".
wait 20.
rcs on.
set ship:control:fore to 1.

set peri to ship:patches.
set t to 0.
until 0{
	if peri[t]:body = BODY("Duna"){
		if peri[t]:periapsis < 12000 and peri[t]:periapsis > 10500 {break.}
		if peri[t]:periapsis < 10500 {set ship:control:fore to -1.}
		if peri[t]:periapsis > 12000 {set ship:control:fore to 1.}
	}
	set t to t+1.
	set peri to ship:patches.
	if t > (peri:length-1) {set t to 0.}	
}

set ship:control:neutralize to true.
rcs off.
wait 5.
sas off.
lock steering to (-1) * ship:velocity:surface.
wait 20.
set warp to 5.
wait until altitude < 1200000.
set warp to 4.
wait until altitude < 340000.
set warp to 3.
wait until altitude < 200000.
set warp to 2.
wait until altitude < 150000.
set warp to 1.
wait until altitude < 140000.
set warp to 0.
wait until altitude < 120000.
stage.

wait until alt:radar < 3500.
lock throttle to 1.
stage.
brakes on.
wait 1.
lock throttle to 0.

function sign{
    parameter x.

    if x > 0{
        return 1.
    }
    else if x < 0{
        return -1.
    }
    else return 0.
}

function nonzero{
    parameter x.
    if x = 0{
        return 1.
    }
    return x.
}

list engines in engs.

lock dspd to -alt:radar*alt:radar/13000 - 1.
lock thr to ( ( 1+0.2* (dspd-ship:verticalspeed)*(dspd-ship:verticalspeed)*sign(dspd-ship:verticalspeed) ) / (nonzero(4*engs[0]:maxthrust) / (ship:mass * 2.94)) ).
lock throttle to thr.

until ship:status = "LANDED"{
    print("altitude = " + alt:radar).
    print("thr = " + thr).
    print("dspd = " + dspd).
    wait 0.1.
    clearscreen.
}

lock throttle to 0.07.
wait 0.1.
stage.
wait 5.
ag4 on.
wait 1.
lights on.