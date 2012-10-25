module QuizzesHelper
  
  # Returns true if the specified quiz_answer is the dragoon's chosen answer.
  def chosen_answer(quiz_question, quiz_answer)
    if params[:results]
      if params[:results][quiz_question.id.to_s] == quiz_answer.id.to_s
        return true
      end
    end
  end
  
  # Returns the dragoon's quiz score.
  def score
    score = 0
    params[:results].each do |key, value|    
      quiz_answer = QuizAnswer.find(value)
      if quiz_answer.correct_answer?
        score = score + 1
      end
    end
    return score
  end
  
end
