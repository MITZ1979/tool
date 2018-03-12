# tool

#User登录
--建立index模块中的Controlller控制器User.php类中的login方法
     
    class User extends Base
    {
         /*登录界面*/
        public function login()
        {   
            //验证是否登录
            $this->alreadyLogin();
            return $this->view->fetch();
        }
        //登录验证 $this->validate($data, $rule, $msq)
    
        public function checkLogin(Request $request)
        {
        
         //初始返回参数
         //从当前方法返回三个变量
          //$status:当前状态
         // $result:提示信息
         // $data:返回数据
         //打包成JSON数据返回前端
         //
        $status = 0;
        $result = '';
        $data = $request->param();

        $rule = [
            'name姓名' => 'require',
            'password密码' => 'require',
            'verify验证码' => 'require|captcha',
        ];
        //自定义验证失败提示信息
        $msg = [
            'name' => ['用户名不能为空,请输入！'],
            'password' => ['密码不能为空,请输入！'],
            'verify' => ['验证码不能为空,请输入！']
        ];
        //进行验证
        $result = $this->validate($rule, $data, $msg);
        if ($result == true) {
            //
            $map = [
                'name' => $data['name'],
                'password' => md5($data['password'])
            ];
            //查询用户信息
            $user = UserModel::get($map);
            if ($user == null) {
                $result = '没有找到该用户';
            } else {
                $status = 1;
                $result = '验证通过,点击【确定】进入';
                Session::set('user_id', $user->id);  //用户id
                Session::set('user_info', $user->getData()); //获取用户所以信息
            }

        }
        return ['status' => $status, 'message' => $result, 'data' => $data];
    }

    //退出登陆
    public function logout()
    {
        //注销登陆
        Session::delete('id');
        Session::delete('user');
        $this->success('注销登陆，正在返回', 'user/login');
    }

    }