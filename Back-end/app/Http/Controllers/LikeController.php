<?php

namespace App\Http\Controllers;

use App\Models\Post;
use App\Models\Like;

class LikeController extends Controller
{
    public function likeOrUnlike($id)
    {
        $post = Post::find($id);

        if(!$post){
            return response([
                'message' => 'Post não encontrado.'
            ],403);            
        }

        //verificar se o usuario ja havia gostado
        $like = $post->likes()->where('user_id',auth()->user()->id)->first();

        if(!$like){
            Like::create([                
                'user_id' => auth()->user()->id,
                'post_id' => $id,
            ]);

            return response([
                'message' => 'Like.'
            ],200);    
        }else{
            $like->delete();
            return response([
                'message' => 'Disliked.'
            ],200);   
        }
    }

}
