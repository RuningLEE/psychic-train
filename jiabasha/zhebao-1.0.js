var ua = navigator.userAgent.toLowerCase();
var zhebao = {
 
    //��ȡҳ���Ƿ��״̬
    getPageState:function (success, fail) {
        getPageStateSuccess = success;
        getPageStateFail = fail;
        
        if (/iphone|ipad|ipod/.test(ua)) {
            alert("bbbb");
           JsModelpageState("getPageStateSuccess","getPageStateFail");

            
        }else if (/android/.test(ua)) {
        	//alert(window.title);
        	
			var result = window.JSBrigeInterface.getPageState();
            success(result);
        } else {
            success(111);
        }
    }


}

var getPageStateSuccess, getPageStateFail;
