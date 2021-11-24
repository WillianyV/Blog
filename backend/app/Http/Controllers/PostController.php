<?php

namespace App\Http\Controllers;

use App\Http\Requests\PostStoreUpdateRequest;
use App\Models\Post;
use Illuminate\Http\Request;

class PostController extends Controller
{
    public function index()
    {
        return response([
            'posts' => Post::orderBy('id','DESC')
                ->with(['user:id,name,image'])
                ->withCount('comments','likes')
                ->with('likes', function($like){
                    return $like
                        ->where('user_id',auth()->user()->id)
                        ->select('id','user_id','post_id')
                        ->get();
                })
                ->get()
        ],200);
    }

    public function store(PostStoreUpdateRequest $request)
    {
        $image = $this->saveImage($request->image, 'posts');

        $post = Post::create([
            'body' => $request->body,
            'user_id' => auth()->user()->id,
            'image' => $image
        ]);

        return response([
            'message' => 'Post criado com sucesso.'
        ],200);
    }

    public function show($id)
    {
        return response([
            'posts' => Post::where('id',$id)->withCount('comments','likes')->get()
        ],200);
    }

    public function update(PostStoreUpdateRequest $request,$id)
    {
        $post = Post::find($id);

        if(!$post){
            return response([
                'message' => 'Post não encontrado.'
            ],403);            
        }

        if($post->user_id != auth()->user()->id){
            return response([
                'message' => 'Permissão negada.'
            ],403);            
        }

        $post->update([
            'body' => $request->body
        ]);

        return response([
            'message' => 'Post editado com sucesso.',
            'post' => $post
        ],200);
    }

    public function destroy($id)
    {
        $post = Post::find($id);

        if(!$post){
            return response([
                'message' => 'Post não encontrado.'
            ],403);            
        }

        if($post->user_id != auth()->user()->id){
            return response([
                'message' => 'Permissão negada.'
            ],403);            
        }

        $post->comments()->delete();
        $post->likes()->delete();
        $post->delete();

        return response([
            'message' => 'Post removido com sucesso.'
        ],200);
    }
}
