# pingplusplus_module
* ping++支付功能封装
* 作者刘明星 lmxbitihero@126.com

在国内做手机支付功能是一个老大难问题，还好ping++这家公司做了一些很好地工作，大大简化了支付功能的实现难度。此module是Appcelerator平台对ping++的封装，同时支持ios和android。

使用方法：
```ruby
var pingpay = require("com.mamashai.pingxx");
pingpay.addEventListener("ping_paid", function(e){
	//code的值可能为success， fail, cancel, invalid, error
	show_alert("提示", "收到了ping_paid信息 code: " + e.code + " text:" + e.text);
});
	
function ios_resume(e){
	var args = Ti.App.getArguments();
	var code = args.url.split("=")[1];
	pingpay.fireEvent("ping_paid", {code: code, text: ''});
}
Ti.App.addEventListener("resumed", ios_resume);
win.addEventListener("close", function(e){
    Ti.App.removeEventListener("ios_resumed", ios_resume);
});

btn.addEventListener("click", function(e){
	pingpay.pay({
		url: "http://bak.mamashai.com:3000/pay/make_payment",
		order_no: "100023",
		amount: "8",					//以分为单位
		channel: "alipay", 				//可选项为：alipay,wx,upmp,jdpay_wap,百度钱包不支持
		url_scheme: "bizsim"
	});
})
```

参数解释：
url：ping++需要在服务端进行配置，这个URL接受客户端的付款请求
order_no：付款之前肯定得先生成订单，付款时传入订单号即可
amount：订单要付款的金额，以分位单位，不是元
channel：可选项为：alipay,wx,upmp,jdpay_wap,bfb安卓下百度钱包不支持
url_scheme：ios下必须传入，付完款后跳回app用的，用xcode打开项目，项目属性->INFO中可以查看，IOS下微信支付对url_scheme参数有特殊要求，详情可见https://pingxx.com/guidance/client/sdk/ios

3：客户端付完款后，ping++会回调server端的notify url，这个比较简单，不涉及到本地端技术，在notify url中获得详细参数，回填各种信息（比如付款时间，付款是否成功等）到付款记录中即可。

4：注意事项
百度钱包android module开发比较麻烦，在国内使用者群体也很小，干脆就没有支持。
