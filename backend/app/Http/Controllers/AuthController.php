<?php

namespace App\Http\Controllers;

use App\Http\Requests\LoginRequest;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class AuthController extends Controller
{
    //registrar usuarios
    public function register(Request $request)
    {
        $attrs = $request->validate([
            'name' => 'required|string',
            'email' => 'required|email|unique:users,email',
            'password' => 'required|min:6'
        ]);

        //criando o usuario
        $user = User::create([
            'name' => $attrs['name'],
            'email' => $attrs['email'],
            'password' => bcrypt($attrs['password']),
        ]);

        //retornando o usuario e o token em response
        return response([
            'user' => $user,
            'token' => $user->createToken('secret')->plainTextToken
        ],200);
    }

    //login
    public function login(LoginRequest $request)
    {
        // $attrs = $request->validate([
        //     'email' => 'required|email',
        //     'password' => 'required|min:6'
        // ]);
        $attrs = ([
            'email' => $request->email,
            'password' =>$request->password
        ]);

        if(!Auth::attempt($attrs)){
            return response([
                'message' => 'E-mail e/ou Senha icorreta.'
            ],400);
        }
        //retornando o usuario e o token em response
        return response([
            'user' => auth()->user(),
            'token' => auth()->user()->createToken('secret')->plainTextToken
        ],200);
    }

    //logout
    public function logout()
    {
        auth()->user()->tokens()->delete();
        return response([
            'message' => 'Logout com sucesso.'
        ],200);
    }

    //pegar o usuario
    public function user()
    {
        return response([
            'user' =>  auth()->user()
        ],200);
    }

    public function update(Request $request)
    {
        $attrs = $request->validate([
            'name' => 'required|string'
        ]);

        $image = $this->saveImage($request->image,'profiles');

        auth()->user()->update([
            'name' => $attrs['name'],
            'image' => $image
        ]);

        return response([
            'message' => 'Usuário editado.',
            'user' =>  auth()->user()
        ],200);
    }
}
