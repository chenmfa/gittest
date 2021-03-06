<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/view/contain/head.jsp" %>
<style>
html{
	height: 100%;
	overflow: hidden;
}
body{
	#background: #000;
	color: #C0C0C0;
	font-weight: bold;
	font-size: 14px;
	font-family: Lucida Console;
	height: 100%;
	margin: 0 0 0 5px;
}
#divContent{
	height: 90%;
	overflow: auto;
}
#txtTimeout{
	width: 40px;
}
button{
	margin-left: 10px;
}
.align-center{
	text-align:center;
}
</style>
<body>
<div id="divInput">
	<span>URL:</span>
	<input id="txtURL" type="text" />
	<span>Timeout:</span>
	<input id="txtTimeout" type="text" value="2000" />
	<input id="btnSwitch" type="button" value="Start" onclick="handleBtnClick()" />
	<hr/>
</div>
<div id="divContent"></div>
<%@ include file="/WEB-INF/view/contain/bottom.jsp" %>
<script>
var intStartTime;  //开始时间

var $ = function(v){return document.getElementById(v)}; //类似jquery的一种封装选择器实现
var arrDelays = [];
var intSent;               //已发送次数
var bolIsRunning = false;  //是否正在执行ping
var bolIsTimeout;          //是否执行超时了
var strURL;                
var intTimeout;
var intTimerID;
var objBtn = $("btnSwitch");
var objContent = $("divContent");
var objTxtURL = $("txtURL");
objTxtURL.value = window.location.host;
//通过image加载的onerror事件来假装一个请求
var objIMG = new Image();
objIMG.onload =
objIMG.onerror = function(){
	/**
	 * 有回应,取消超时计时
	 */
	//clearTimeout() 方法可取消由 
	//setTimeout() 方法设置的 timeout
	clearTimeout(intTimerID);  
	if(!bolIsRunning || bolIsTimeout)
		return;
	var delay = new Date().getTime() - intStartTime; //
	println("Reply from " +
	strURL +" time" +
	((delay<1)?("<1"):("="+delay)) +
	"ms");
	arrDelays.push(delay); //把每次的延迟放到数组里面
	/*
	* 每次请求间隔限制在1秒以上
	*/
	setTimeout(ping, delay<1000?(1000-delay):1000);
}
function ping(){
	/**
	 * 发送请求
	 */
	intStartTime = +new Date(); //也可以用new Date().getTime();
	intSent++;
	objIMG.src = strURL + "/" + intStartTime;
	bolIsTimeout = false;
	/*
	* 超时计时
	*/
	intTimerID = setTimeout(timeout, intTimeout);
}
function timeout(){
	if(!bolIsRunning)
		return;
	bolIsTimeout = true;
	objIMG.src = "X:\\";
	println("Request timed out.");
	ping();
}


function handleBtnClick()
{
	if(bolIsRunning){
		/**
		 * 停止
		 */
		var intRecv = arrDelays.length;  //ping成功的次数
		var intLost = intSent-intRecv;   //发送次数-成功次数
		var sum = 0;  //用于计算总的延迟
		for(var i=0; i<intRecv; i++)
			sum += arrDelays[i]; 
			objBtn.value = "Start";
			bolIsRunning = false;
		/**
		 * 统计结果
		 */
		println("　");
		println("Ping statistics for " + strURL + ":");
		println("　　Packets: Sent = " +
		intSent +
		", Received = " +
		intRecv +
		", Lost = " +
		intLost +
		" (" +
		Math.floor(intLost / intSent * 100) +
		"% loss),");
		if(intRecv == 0)
		return;
		println("Approximate round trip times in milli-seconds:");
		println("　　Minimum = " +
		Math.min.apply(this, arrDelays) +
		"ms, Maximum = " +
		Math.max.apply(this, arrDelays) +
		"ms, Average = " +
		Math.floor(sum/intRecv) +"ms");
	}
	else{
		/*
		* 开始
		*/
		strURL = objTxtURL.value; //获取输入框的值
		if(strURL.length == 0)
			return; //未输入地址，返回
		if(strURL.substring(0,7).toLowerCase() != "http://")
			strURL = "http://" + strURL;
		intTimeout = parseInt($("txtTimeout").value, 10); //10进制
		if(isNaN(intTimeout)){
			intTimeout = 2000;
		}else if(intTimeout < 1000){
			intTimeout = 1000;
		}
		objBtn.value = "Stop ";
		bolIsRunning = true;
		arrDelays = [];
		intSent = 0;
		cls();
		println("Pinging " + strURL + ":");
		println("　");
		ping();
	}
}
function println(str){
	//创建一个div对象
	var objDIV = document.createElement("div");
	if(objDIV.innerText != null)
	 objDIV.innerText = str;
	else
	 objDIV.textContent = str;
	 objContent.appendChild(objDIV);
	 //objContent.scrollTop = objContent.scrollHeight;
}
//清除内容
function cls(){
	objContent.innerHTML = "";
}
</script>
<div class="align-center">
	如不能显示效果，请按Ctrl+F5刷新本页，更多网页代码：
	<a href='http://www.cheermanfa.com/' target='_blank'>
		http://www.cheermanfa.com/
	</a>
</div>
</body>
</html>