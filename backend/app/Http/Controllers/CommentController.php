<?php

namespace App\Http\Controllers;

use App\Http\Requests\CommentStoreUpdateRequest;
use Illuminate\Http\Request;
use App\Models\Post;
use App\Models\Comment;

class CommentController extends Controller
{
    public function index($id)
    {
        $post = Post::find($id);

        if(!$post){
            return response([
                'message' => 'Post não encontrado.'
            ],403);            
        }

        return response([
            'post' => $post->comments()->with('user:id,name,image')->get()
        ],200);
    }

    public function store(CommentStoreUpdateRequest $request,$id)
    {
        $post = Post::find($id);

        if(!$post){
            return response([
                'message' => 'Post não encontrado.'
            ],403);            
        }

        Comment::create([
            'comment' => $request->comment,
            'post_id' => $id,
            'user_id' => auth()->user()->id
        ]);

        return response([
            'message' => 'Comentario postado com sucesso.'
        ],200);
    }

    public function update(CommentStoreUpdateRequest $request,$id)
    {
        $comment = Comment::find($id);

        if(!$comment){
            return response([
                'message' => 'Comentário não encontrado.'
            ],403);            
        }

        if($comment->user_id != auth()->user()->id){
            return response([
                'message' => 'Permissão negada.'
            ],403);            
        }

        $comment->update([
            'comment' => $request->comment
        ]);

        return response([
            'message' => 'Comentário editado com sucesso.',
            'comment' => $comment
        ],200);
    }
    public function destroy($id)
    {
        $comment = Comment::find($id);

        if(!$comment){
            return response([
                'message' => 'Comentário não encontrado.'
            ],403);            
        }

        if($comment->user_id != auth()->user()->id){
            return response([
                'message' => 'Permissão negada.'
            ],403);            
        }

        $comment->delete();

        return response([
            'message' => 'Comentario removido com sucesso.'
        ],200);
    }

}
